import { JSDOM } from 'jsdom'
request = require('request-promise-native')

import { GROUPS } from '../../client/lib/informaticsGroups'

import RegisteredUser from '../models/registeredUser'
import User from '../models/user'

import download from '../lib/download'
import logger from '../log'

import TestSystem, {TestSystemUser} from './TestSystem'

import InformaticsSubmitDownloader from './informatics/InformaticsSubmitDownloader'


REQUESTS_LIMIT = 20
UNKNOWN_GROUP = '7647'


class InformaticsUser extends TestSystemUser
    constructor: (@id) ->
        super()

    profileLink: () ->
        "https://informatics.msk.ru/user/view.php?id=#{@id}&course=1"


userCache = {}

class LoggedInformaticsUser
    @getUser: (username, password) ->
        key = username + "::" + password
        if not userCache[key] or not (await userCache[key].getId())
            logger.info "Creating new InformaticsUser ", username
            newUser = new LoggedInformaticsUser(username, password)
            await newUser._login()
            userCache[key] = newUser
            logger.info "Created new InformaticsUser ", username
        return userCache[key]

    constructor: (@username, @password) ->
        @jar = request.jar()
        @requests = 0
        @promises = []

    _login: () ->
        logger.info "Logging in new InformaticsUser ", @username
        try
            page = await download("https://informatics.msk.ru/login/index.php", @jar, {
                method: 'POST',
                form: {
                    username: @username,
                    password: @password
                },
                followAllRedirects: true,
                timeout: 30 * 1000
            })
            @id = await @getId()
            if not @id
                throw "Can not log user #{@username} in"
            logger.info "Logged in new InformaticsUser ", @username
        catch e
            logger.error "Can not log in new Informatics user #{@username}", e.message, e

    getId: () ->
        page = await download("https://informatics.msk.ru/", @jar)
        document = (new JSDOM(page)).window.document
        el = document.getElementsByClassName("logininfo")
        if el.length == 0 or el[0].children.length == 0
            return null
        a = el[0].children[0]
        id = a.href.match(/view.php\?id=(\d+)/)
        @name = a.innerHTML
        if not id or id.length < 2
            return null
        return id[1]

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

    _runSubmit: (problemId, addParams) ->
        page = await download("https://informatics.msk.ru/py/problem/#{problemId}/submit", @jar, {
            addParams...,
            method: 'POST',
            followAllRedirects: true,
            timeout: 30 * 1000,
            maxAttempts: 1
        })
        res = JSON.parse(page)
        if res.res != "ok"
            throw "Can't submit"

    submit: (problemId, contentType, body) ->
        @_runSubmit(problemId, {
            headers: {'Content-Type': contentType},
            body,
        })

    submitWithObject: (problemId, data) ->
        @_runSubmit(problemId, {
            formData: {
                lang_id: data.language
                file: {
                    value: Buffer.from(data.source, "latin1")
                    options: {
                        filename: 'a',
                        contentType: 'text/plain'
                    }
                }
            },
        })

export default class Informatics extends TestSystem
    BASE_URL = "https://informatics.msk.ru"

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

    submitDownloader: (userId, problemId, fromTimestamp, submitsPerPage) ->
        problemId = if problemId then @_informaticsProblemId(problemId) else 0
        if userId or problemId
            groupId = 0
        else
            userId = 0
            groupId = GROUPS["unknown"]
        fromTimestamp = fromTimestamp || 0
        if userId
            fullUser = await RegisteredUser.findByKey(userId)
            user = await LoggedInformaticsUser.getUser(fullUser.informaticsUsername, fullUser.informaticsPassword)
        else
            # disable all downloads except for a specific user
            return
        url = (page) ->
            "#{BASE_URL}/py/problem/#{problemId}/filter-runs?problem_id=#{problemId}&from_timestamp=-1&to_timestamp=-1&group_id=#{groupId}&user_id=#{userId}&lang_id=-1&status_id=-1&statement_id=0&count=#{submitsPerPage}&with_comment=&page=#{page}
            "#{BASE_URL}/moodle/ajax/ajax.php?problem_id=#{problemId}&group_id=#{groupId}&user_id=#{userId}&from_timestamp=#{fromTimestamp}&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=#{submitsPerPage}&with_comment=&page=#{page}&action=getHTMLTable"
        return new InformaticsSubmitDownloader(user, url)

    submitNeedsFormData: () ->
        true

    submitWithObject: (user, problemId, data) ->
        informaticsProblemId = @_informaticsProblemId(problemId)
        logger.info "Try submit #{user.username}, #{user.informaticsId} #{problemId}"
        informaticsUser = await LoggedInformaticsUser.getUser(user.informaticsUsername, user.informaticsPassword)
        await informaticsUser.submitWithObject(informaticsProblemId, data)

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

    selfTest: () ->
        await @_getAdmin()
