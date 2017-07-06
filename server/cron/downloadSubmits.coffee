request = require('request-promise-native')
import Submit from '../models/submit'
import User from '../models/user'
import Problem from '../models/problem'
import Table from '../models/table'

import updateResults from '../calculations/updateResults'

class AllSubmitDownloader
    
    constructor: (@baseUrl, @userList, @submitsPerPage, @minPages, @limitPages) ->
        @addedUsers = {}
        @dirtyResults = {}
    
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
            console.log "unknown problem ", probid
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

    processSubmit: (uid, name, pid, runid, prob, date, outcome) ->
        res = await @needContinueFromSubmit(runid)
        if (outcome == @CE)
            outcome = "CE"
        if (outcome == @AC) 
            outcome = "AC"
        if (outcome == @IG) 
            outcome = "IG"
        if (outcome == @DQ) 
            outcome = "DQ"

        await new Submit(
            _id: runid,
            time: date,
            user: uid,
            problem: "p" + pid,
            outcome: outcome
        ).upsert()
        await new User(
            _id: uid,
            name: name,
            userList: @userList
        ).upsert()
        @addedUsers[uid] = uid
        await @setDirty(uid, "p"+pid)
        res
    
    parseSubmits: (submitsTable) ->
        submitsRows = submitsTable.split("<tr>")
        result = true
        wasSubmit = false
        resultPromises = []
        for row in submitsRows
            re = new RegExp '<td>[^<]*</td>\\s*<td><a href="/moodle/user/view.php\\?id=(\\d+)">([^<]*)</a></td>\\s*<td><a href="/moodle/mod/statements/view3.php\\?chapterid=(\\d+)&run_id=([0-9r]+)">([^<]*)</a></td>\\s*<td>([^<]*)</td>\\s*<td>[^<]*</td>\\s*<td>([^<]*)</td>', 'gm'
            data = re.exec row
            if not data
                continue
            uid = data[1]
            name = data[2]
            pid = data[3]
            runid = data[4] + "p" + pid
            prob = data[5]
            date = data[6]
            outcome = data[7].trim()
            resultPromises.push(@processSubmit(uid, name, pid, runid, prob, date, outcome))
            wasSubmit = true
        results = await Promise.all(resultPromises)
        result = wasSubmit
        for r in results
            result = result and r
        return result
    
    processAddedUser: (uid) ->
        await updateResults(uid, @dirtyResults)
        u = await User.findById(uid)
        await u.updateChocos()
        await u.updateRatingEtc()
        await u.updateLevel()
    
    run: ->
        console.log "AllSubmitDownloader::run ", @userList, @submitsPerPage, @minPages, '-', @limitPages
        page = 0
        while true
            submitsUrl = @baseUrl(page, @submitsPerPage)
            submits = await request
                url: submitsUrl
                jar: request.jar()
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
            addedPromises.push(@processAddedUser(uid))
        await Promise.all(addedPromises)
        console.log "Finish AllSubmitDownloader::run ", @userList, @limitPages
            
class LastSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        !await Submit.findById(runid)

class UntilIgnoredSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        res = (await Submit.findById(runid))?.outcome
        r = !((res == "AC") || (res == "IG"))
        return r

# Лицей 40
lic40url = (page, submitsPerPage) ->
        'http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=5401&user_id=0&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=' + submitsPerPage + '&with_comment=&page=' + page + '&action=getHTMLTable'
        
# Заоч
zaochUrl = (page, submitsPerPage) ->
    'http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=5402&user_id=0&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=' + submitsPerPage + '&with_comment=&page=' + page + '&action=getHTMLTable'

export runAll = () ->
    (new AllSubmitDownloader(lic40url, 'lic40', 1000, 1, 1e9)).run()
    (new AllSubmitDownloader(zaochUrl, 'zaoch', 1000, 1, 1e9)).run()
    
export runUntilIgnored = () -> 
    (new UntilIgnoredSubmitDownloader(lic40url, 'lic40', 100, 2, 4)).run()
    (new UntilIgnoredSubmitDownloader(zaochUrl, 'zaoch', 100, 2, 4)).run()
    
export runLast = () ->
    (new LastSubmitDownloader(lic40url, 'lic40', 20, 1, 1)).run()
    (new LastSubmitDownloader(zaochUrl, 'zaoch', 20, 1, 1)).run()
