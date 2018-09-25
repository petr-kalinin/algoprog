import { JSDOM } from 'jsdom'
request = require('request-promise-native')

import { GROUPS } from '../../client/lib/informaticsGroups'

import RegisteredUser from '../models/registeredUser'
import Submit from '../models/submit'

import download from '../lib/download'
import logger from '../log'

import TestSystem, {TestSystemUser} from './TestSystem'

import InformaticsSubmitDownloader from './informatics/InformaticsSubmitDownloader'
import * as downloadSubmits from '../cron/downloadSubmits'


REQUESTS_LIMIT = 20
UNKNOWN_GROUP = '7647'


class InformaticsUser extends TestSystemUser
    constructor: (@id) ->
        super()

    profileLink: () ->
        "https://informatics.mccme.ru/user/view.php?id=#{@id}&course=1"


userCache = {}

class LoggedInformaticsUser
    @getUser: (username, password) ->
        key = username + "::" + password
        if not userCache[key] or (new Date() - userCache[key].loginTime > 1000 * 60 * 60)
            logger.info "Creating new InformaticsUser ", username
            newUser = new LoggedInformaticsUser(username, password)
            await newUser._login()
            userCache[key] =
                user: newUser
                loginTime: new Date()
        return userCache[key].user

    constructor: (@username, @password) ->
        @jar = request.jar()
        @requests = 0
        @promises = []

    _login: () ->
        page = await download("https://informatics.mccme.ru/login/index.php", @jar, {
            method: 'POST',
            form: {
                username: @username,
                password: @password
            },
            followAllRedirects: true,
            timeout: 30 * 1000
        })
        document = (new JSDOM(page)).window.document
        el = document.getElementsByClassName("logininfo")
        if el.length == 0 or el[0].children.length == 0
            throw "Can't log user #{username} in"
        a = el[0].children[0]
        id = a.href.match(/view.php\?id=(\d+)/)
        @name = a.innerHTML
        if not id or id.length < 2
            throw "Can't detect id, href=#{a.href} username=#{@username}"
        logger.info "Logged in user #{@username} href=#{a.href}"
        @id = id[1]

    download: (href, options) ->
        if @requests >= REQUESTS_LIMIT
            await new Promise((resolve) => @promises.push(resolve))
        if @requests >= REQUESTS_LIMIT
            throw "Too many requests"
        @requests++
        try
            result = await download(href, @jar, options)
        finally
            @requests--
            if @promises.length
                promise = @promises.shift()
                promise(0)  # resolve
        return result

    submit: (problemId, contentType, body) ->
        page = await download("https://informatics.mccme.ru/py/problem/#{problemId}/submit", @jar, {
            method: 'POST',
            headers: {'Content-Type': contentType},
            body,
            followAllRedirects: true
        })
        res = JSON.parse(page)
        if res.res != "ok"
            throw "Can't submit"


export default class Informatics extends TestSystem
    BASE_URL = "https://informatics.mccme.ru"

    _informaticsProblemId: (problemId) ->
        problemId.substring(1)

    _getAdmin: () ->
        admin = await RegisteredUser.findAdmin()
        return LoggedInformaticsUser.getUser(admin.informaticsUsername, admin.informaticsPassword)

    id: () ->
        return "informatics"

    problemLink: (problemId) ->
        id = @_informaticsProblemId(problemId)
        "#{BASE_URL}/moodle/mod/statements/view3.php?chapterid=#{id}"

    submitListLink: (problemId, userId) ->
        id = @_informaticsProblemId(problemId)
        "#{BASE_URL}/moodle/mod/statements/view3.php?" + "chapterid=#{id}&submit&user_id=#{userId}"

    setOutcome: (submitId, outcome, comment) ->
        throw "Will not set outcome on Informatice"
        adminUser = await @_getAdmin()
        [fullSubmitId, contest, run, problem] = submitId.match(/(\d+)r(\d+)p(\d+)/)
        outcomeCode = switch outcome
            when "AC" then 8
            when "IG" then 9
            when "DQ" then 10
            else undefined
            
        try
            if outcomeCode
                href = "#{BASE_URL}/py/run/rejudge/#{contest}/#{run}/#{outcomeCode}"
                await adminUser.download(href, {maxAttempts: 1})
        finally
            if comment
                href = "#{BASE_URL}/py/comment/add"
                body =
                    run_id: run
                    contest_id: contest
                    comment: comment
                    lines: ""
                await adminUser.download(href, {
                    method: 'POST',
                    headers: {'Content-Type': "application/x-www-form-urlencoded; charset=UTF-8"},
                    form: body,
                    followAllRedirects: true
                    maxAttempts: 1
                })
        logger.info "Successfully set outcome for #{submitId}"

    submitDownloader: (userId, problemId, submitsPerPage) ->
        problemId = if problemId then @_informaticsProblemId(problemId) else 0
        if userId or problemId
            groupId = 0
        else
            userId = 0
            groupId = GROUPS["unknown"]
        url = (page) ->
            "#{BASE_URL}/moodle/ajax/ajax.php?problem_id=#{problemId}&group_id=#{groupId}&user_id=#{userId}&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=#{submitsPerPage}&with_comment=&page=#{page}&action=getHTMLTable"
        return new InformaticsSubmitDownloader(await @_getAdmin(), url)

    submitNeedsFormData: () ->
        true

    submitWithFormData: (user, problemId, contentType, data) ->
        informaticsProblemId = @_informaticsProblemId(problemId)
        try
            oldSubmits = await Submit.findByUserAndProblem(user.informaticsId, problemId)
            try
                informaticsUser = await LoggedInformaticsUser.getUser(user.informaticsUsername, user.informaticsPassword)
                informaticsData = await informaticsUser.submit(informaticsProblemId, contentType, data)
            finally
                await downloadSubmits.runForUser(user.informaticsId, 5, 1)
        catch e
            newSubmits = await Submit.findByUserAndProblem(user.informaticsId, problemId)
            if oldSubmits.length == newSubmits.length
                throw e

    registerUser: (user) ->
        logger.info "Moving user #{user._id} to unknown group"
        adminUser = await @_getAdmin()

        href = "#{BASE_URL}/moodle/ajax/ajax.php?sid=&objectName=group&objectId=#{UNKNOWN_GROUP}&selectedName=users&action=add"
        body = 'addParam={"id":"' + user._id + '"}&group_id=&session_sid='
        await adminUser.download(href, {
            method: 'POST',
            headers: {'Content-Type': "application/x-www-form-urlencoded; charset=UTF-8"},
            body: body,
            followAllRedirects: true
        })
