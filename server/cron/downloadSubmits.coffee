request = require('request-promise-native')
deepEqual = require('deep-equal')
moment = require('moment')
import { JSDOM } from 'jsdom'

import Submit from '../models/submit'
import SubmitComment from '../models/SubmitComment'
import User from '../models/user'
import RegisteredUser from '../models/registeredUser'
import Problem from '../models/problem'
import Table from '../models/table'
import InformaticsUser from '../informatics/InformaticsUser'

import logger from '../log'
import download from '../lib/download'

import * as groups from '../informatics/informaticsGroups'

class AllSubmitDownloader

    constructor: (@baseUrl, @userList, @submitsPerPage, @minPages, @limitPages) ->
        @addedUsers = {}
        @dirtyResults = {}
        @_forceMetadata = false

    forceMetadata: () ->
        @_forceMetadata = true
        return this

    AC: 'Зачтено/Принято'
    IG: 'Проигнорировано'
    DQ: 'Дисквалифицировано'
    CE: 'Ошибка компиляции'

    addedUsers: {}

    needContinueFromSubmit: (runid) ->
        true

    setDirty: (userId, probid) ->
        @dirtyResults[userId + "::" + probid] = 1
        problem = await Problem.findById(probid)
        if not problem
            return
        for table in problem.tables
            t = table
            while true
                t = await Table.findById(t)
                if t._id == Table.main
                    break
                @dirtyResults[userId + "::" + t._id] = 1
                t = t.parent
        @dirtyResults[userId + "::" + Table.main] = 1

    parseRunId: (runid) ->
        [fullMatch, contest, run] = runid.match(/(\d+)r(\d+)p(\d+)/)
        return [contest, run]

    getSource: (runid) ->
        try
            [contest, run] = @parseRunId(runid)
            href = "http://informatics.mccme.ru/moodle/ajax/ajax_file.php?objectName=source&contest_id=#{contest}&run_id=#{run}"
            page = await @adminUser.download(href, {encoding: 'latin1'})
            document = (new JSDOM(page)).window.document
            source = document.getElementById("source-textarea").innerHTML
            return source
        catch e
            logger.info "Can't download source ", runid, href, e
            return ""

    getComments: (problemId, userId, runid, outcome) ->
        try
            [contest, run] = @parseRunId(runid)
            href = "http://informatics.mccme.ru/py/comment/get/#{contest}/#{run}"
            data = await @adminUser.download(href)
            comments = JSON.parse(data).comments
            if not comments
                return []
            result = []
            for c in comments
                result.push(c.comment)
                problem = await Problem.findById(problemId)
                newComment = new SubmitComment
                    _id: c.id + "r" + runid
                    problemId: problemId
                    problemName: problem.name
                    userId: userId
                    text: c.comment
                    time: new Date(moment(c.date + "+03"))
                    outcome: outcome
                await newComment.upsert()

            return (c.comment for c in comments)
        catch e
            logger.info "Can't download comments ", runid, href, e.stack
            return []

    getResults: (runid) ->
        try
            [contest, run] = @parseRunId(runid)
            href = "http://informatics.mccme.ru/py/protocol/get/#{contest}/#{run}"
            data = await @adminUser.download(href)
            return JSON.parse(data)
        catch
            logger.info "Can't download results ", runid, href
            # mark so that it will not be re-downloaded
            return {failed: true}

    mergeComments: (c1, c2) ->
        result = c1
        for c in c2
            if not (c in result)
                result.push(c)
        return result

    removeUserFromUnknownGroup: (uid) ->
        await groups.removeUserFromGroup(@adminUser, uid, "unknown")

    processSubmit: (uid, name, pid, runid, prob, date, language, outcome) ->
        logger.debug "Found submit ", uid, pid, runid, prob, date, language, outcome
        res = await @needContinueFromSubmit(runid)
        if (outcome == @CE)
            outcome = "CE"
        if (outcome == @AC)
            outcome = "AC"
        if (outcome == @IG)
            outcome = "IG"
        if (outcome == @DQ)
            outcome = "DQ"

        oldSubmit = await Submit.findById(runid)
        oldUser = await User.findById(uid)

        date = new Date(moment(date + "+03"))

        newSubmit = new Submit(
            _id: runid,
            time: date,
            user: uid,
            problem: "p" + pid,
            outcome: outcome
            language: language
        )
        newUser = new User(
            _id: uid,
            name: name,
            userList: @userList
        )

        if oldSubmit
            oldSubmit = oldSubmit.toObject()
            newSubmit.source = oldSubmit.source
            newSubmit.results = oldSubmit.results
            newSubmit.comments = oldSubmit.comments
            newSubmit.quality = oldSubmit.quality
        # we can't compare oldUser and newUser because they will have different rating, etc
        if (oldSubmit and newSubmit and deepEqual(oldSubmit, newSubmit.toObject()) \
                and oldUser and oldUser.userList == newUser.userList \
                and oldSubmit.results \
                and not @_forceMetadata)
            logger.debug "Submit already in the database #{runid}"
            return res

        if oldSubmit and oldSubmit?.force and not @_forceMetadata
            logger.info("Will not overwrite a forced submit #{runid}")
            await @setDirty(uid, "p"+pid)
            return res

        if @_forceMetadata and oldSubmit?.force
            newSubmit.outcome = oldSubmit.outcome
            newSubmit.force = oldSubmit.force

        [source, comments, results] = await Promise.all([
            @getSource(runid),
            @getComments(newSubmit.problem, newSubmit.user, runid, newSubmit.outcome),
            @getResults(runid)
        ])

        newSubmit.source = source
        newSubmit.results = results
        newSubmit.comments = @mergeComments(newSubmit.comments, comments)

        logger.debug "Adding submit", uid, pid, runid
        await newSubmit.upsert()
        await newUser.upsert()
        if newUser.userList != "unknown" and oldUser and oldUser.userList == "unknown"
            await @removeUserFromUnknownGroup(uid)
        @addedUsers[uid] = uid
        await @setDirty(uid, "p"+pid)
        logger.debug "Done submit", uid, pid, runid, res
        res

    parseSubmits: (submitsTable) ->
        submitsRows = submitsTable.split("<tr>")
        result = true
        wasSubmit = false
        resultPromises = []
        for row in submitsRows
            ###
            <td>104-4934</td>
            <td><a href="/moodle/user/view.php?id=26405">Катя Дедович</a></td>
            <td><a href="/moodle/mod/statements/view3.php?chapterid=585&run_id=104r4934">585. Фонтан</a></td>
            <td>2018-03-23 17:12:28</td>
            <td>GNU C++ 7.2.0</td>
            <td>                <select name="5abd38fda24ee" class="round_sb" onChange="rejudgeRun(104, 4934, this)">
<option value="0" disabled>---</option>
<option value="r0"  >OK</option>
<option value="r99"  >Перетестировать</option>
<option value="r8"  >Зачтено/Принято</option>
<option value="r14"  >Ошибка оформления кода</option>
<option value="r9"  >Проигнорировано</option>
<option value="r1"  >Ошибка компиляции</option>
<option value="r10"  >Дисквалифицировано</option>
<option value="r7" selected="selected" >Частичное решение</option>
<option value="r11"  >Ожидает проверки</option>
<option value="r2"   disabled >Ошибка во время выполнения программы</option>
<option value="r3"   disabled >Превышено максимальное время работы</option>
<option value="r4"   disabled >Неправильный формат вывода</option>
<option value="r5"   disabled >Неправильный ответ</option>
<option value="r6"   disabled >Ошибка проверки,<br/>обратитесь к администраторам</option>
<option value="r12"   disabled >Превышение лимита памяти</option>
<option value="r13"   disabled >Security error</option>
<option value="r96"   disabled >Тестирование...</option>
<option value="r98"   disabled >Компилирование...</option>
</select>             </td>
            <td>6</td>
            <td>6</td>
            <td><a onclick="loadSourceWindow(104, 4934, '1');return false;" href="/moodle/ajax/ajax_file.php?objectName=source&contest_id=104&run_id=4934">Подробнее</a></td>
            ###
            re = new RegExp '<td>[^<]*</td>\\s*<td><a href="/moodle/user/view.php\\?id=(\\d+)">([^<]*)</a></td>\\s*<td><a href="/moodle/mod/statements/view3.php\\?chapterid=(\\d+)&run_id=([0-9r]+)">([^<]*)</a></td>\\s*<td>([^<]*)</td>\\s*<td>([^<]*)</td>\\s*<td>([^]*?)</td>', 'gm'
            outcomeRe = new RegExp '<option value="[^"]*" selected="selected"[^>]*>([^<]*)<', 'gm'
            data = re.exec row
            if not data
                logger.warn "Submit not found in line"
                continue
            uid = data[1]
            name = data[2]
            pid = data[3]
            runid = data[4] + "p" + pid
            prob = data[5]
            date = data[6]
            language = data[7]
            outcome = data[8]
            outcome = outcomeRe.exec outcome
            if not outcome
                logger.warn "No outcome found `#{data[8]}`"
                continue
            outcome = outcome[1]
            resultPromises.push(@processSubmit(uid, name, pid, runid, prob, date, language, outcome))
            wasSubmit = true
        results = await Promise.all(resultPromises)
        result = wasSubmit
        for r in results
            result = result and r
        return result

    processAddedUser: (uid) ->
        User.updateUser(uid, @dirtyResults)

    run: ->
        logger.info "AllSubmitDownloader.run ", @userList, @submitsPerPage, @minPages, '-', @limitPages

        @adminUser = await InformaticsUser.findAdmin()

        page = 0
        while true
            logger.info("Dowloading submits, page #{page}")
            submitsUrl = @baseUrl(page, @submitsPerPage)
            submits = await @adminUser.download submitsUrl
            submits = JSON.parse(submits)["result"]["text"]
            result = await @parseSubmits(submits)
            if (page < @minPages) # always load at least minPages pages
                result = true
            if not result
                break
            page = page + 1
            if page > @limitPages
                break

        tables = await Table.find({})
        addedPromises = []
        for uid, tmp of @addedUsers
            logger.debug "Will process added user ", uid
            addedPromises.push(@processAddedUser(uid))
        await Promise.all(addedPromises)
        logger.info "Finish AllSubmitDownloader.run ", @userList, @limitPages

class LastSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        !await Submit.findById(runid)

class UntilIgnoredSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        res = (await Submit.findById(runid))?.outcome
        r = !((res == "AC") || (res == "IG"))
        return r

userProblemUrl = (userId, problemId) ->
    (page, submitsPerPage) ->
        "http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=#{problemId}&group_id=0&user_id=#{userId}&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=#{submitsPerPage}&with_comment=&page=#{page}&action=getHTMLTable"

userUrl = (userId) ->
    (page, submitsPerPage) ->
        "http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=0&user_id=#{userId}&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=#{submitsPerPage}&with_comment=&page=#{page}&action=getHTMLTable"

url = (group) -> (page, submitsPerPage) ->
        "http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=#{group}&user_id=0&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=#{submitsPerPage}&with_comment=&page=#{page}&action=getHTMLTable"

urls = {}
for group, infGroup of groups.GROUPS
    urls[group] = url(infGroup)


running = false

wrapRunning = (callable) ->
    () ->
        if running
            logger.info "Already running downloadSubmits"
            return
        try
            running = true
            await callable()
        finally
            running = false


export runForUser = (userId, submitsPerPage, maxPages) ->
    try
        user = await User.findById(userId)
        await (new AllSubmitDownloader(userUrl(userId), user.userList, submitsPerPage, 1, maxPages)).run()
    catch e
        logger.error "Error in runForUser", e

export runForUserAndProblem = (userId, problemId) ->
    try
        user = await User.findById(userId)
        iProblemId = problemId.substr(1)
        await (new AllSubmitDownloader(userProblemUrl(userId, iProblemId), user.userList, 100, 1, 10)).forceMetadata().run()
    catch e
        logger.error "Error in runForUserAndProblem", e


export runAll = wrapRunning () ->
    try
        for group, url of urls
            await (new AllSubmitDownloader(url, group, 1000, 1, 1e9)).run()
    catch e
        logger.error "Error in AllSubmitDownloader", e

export runUntilIgnored = wrapRunning () ->
    try
        for group, url of urls
            await (new UntilIgnoredSubmitDownloader(url, group, 100, 2, 4)).run()
    catch e
        logger.error "Error in UntilIgnoredSubmitDownloader", e

export runLast = wrapRunning () ->
    try
        for group, url of urls
            await (new LastSubmitDownloader(url, group, 20, 1, 1)).run()
    catch e
        logger.error "Error in LastSubmitDownloader", e
