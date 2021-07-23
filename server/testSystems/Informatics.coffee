import { JSDOM } from 'jsdom'
request = require('request-promise-native')

import { GROUPS } from '../../client/lib/informaticsGroups'

import RegisteredUser from '../models/registeredUser'
import User from '../models/user'

import download, {downloadLimited} from '../lib/download'
import sleep from '../lib/sleep'
import logger from '../log'

import TestSystem, {TestSystemUser} from './TestSystem'

import InformaticsSubmitDownloader from './informatics/InformaticsSubmitDownloader'


REQUESTS_LIMIT = 1
UNKNOWN_GROUP = '7647'
TIMEOUT = 1000
_requests = 0
_promises = []

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
            page = await @download('https://informatics.msk.ru/login/index.php')
            token = /<input type="hidden" name="logintoken" value="([^"]*)">/.exec(page)?[1]
            page = await @download("https://informatics.msk.ru/login/index.php", {
                method: 'POST',
                form: {
                    username: @username,
                    password: @password,
                    logintoken: token
                },
                followAllRedirects: true,
                timeout: 30 * 1000
            })
            if page.includes("Неверный логин или пароль")
                throw { badPassword: true }
            @id = await @getId()
            if not @id
                throw "Can not log user #{@username} in"
            logger.info "Logged in new InformaticsUser ", @username
        catch e
            if e.badPassword
                throw e
            logger.error "Can not log in new Informatics user #{@username}", e.message, e

    getId: () ->
        page = await @download("https://informatics.msk.ru/")
        @name = /<span class="userbutton"><span class="usertext mr-1">([^<]*)</.exec(page)?[1]
        id = /<a href="https:\/\/informatics.msk.ru\/user\/profile.php\?id=(\d+)"/.exec(page)?[1]
        if not @name or not id or id.length < 2
            return null
        return id[1]

    download: (href, options) ->
        if _requests >= REQUESTS_LIMIT
            await new Promise((resolve) => _promises.push(resolve))
        if _requests >= REQUESTS_LIMIT
            throw "Too many requests"
        _requests++
        await sleep(TIMEOUT)
        try
            result = await download(href, @jar, options)
        finally
            _requests--
            if _promises.length
                promise = _promises.shift()
                promise(0)  # resolve
        return result

    _runSubmit: (problemId, addParams) ->
        page = await @download("https://informatics.msk.ru/py/problem/#{problemId}/submit", {
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
        if not admin
            return undefined
        return LoggedInformaticsUser.getUser(admin.informaticsUsername, admin.informaticsPassword)

    id: () ->
        return "informatics"

    submitDownloader: (registeredUser, problem, submitsPerPage) ->
        userId = registeredUser.informaticsId
        problemId = @_informaticsProblemId(problem._id)
        groupId = 0
        fromTimestamp = 0
        user = await @_getAdmin()
        admin = true
        if not user
            user = await LoggedInformaticsUser.getUser(registeredUser.informaticsUsername, registeredUser.informaticsPassword)
            admin = false
        url = (page) ->
            "#{BASE_URL}/py/problem/#{problemId}/filter-runs?problem_id=#{problemId}&from_timestamp=-1&to_timestamp=-1&group_id=#{groupId}&user_id=#{userId}&lang_id=-1&status_id=-1&statement_id=0&count=#{submitsPerPage}&with_comment=&page=#{page}"
        return new InformaticsSubmitDownloader(user, url, admin, userId)

    submitNeedsFormData: () ->
        true

    submitWithObject: (user, problemId, data) ->
        informaticsProblemId = @_informaticsProblemId(problemId)
        logger.info "Try submit #{user.username}, #{user.informaticsId} #{problemId}"
        informaticsUser = await LoggedInformaticsUser.getUser(user.informaticsUsername, user.informaticsPassword)
        await informaticsUser.submitWithObject(informaticsProblemId, data)

    registerUser: (user) ->
        

    selfTest: () ->
        await @_getAdmin()

    downloadProblem: (options) ->
        href = "https://informatics.msk.ru/mod/statements/view.php?chapterid=#{options.id}"
        page = await downloadLimited(href, {timeout: 15 * 1000})
        document = (new JSDOM(page, {url: href})).window.document
        submit = document.getElementById('submit')
        if submit
            submit.parentElement.removeChild(submit)

        data = document.getElementsByClassName("problem-statement")
        if not data or data.length == 0
            logger.warn("Can't find statement for problem " + href)
            data = []

        name = document.getElementsByTagName("title")[0] || ""
        name = /^Задача №\d+. (.*)$/.exec(name.innerHTML)?[1]

        if not name
            logger.warn Error("Can't find name for problem " + href)
            name = "???"

        text = "<h1>" + name + "</h1>"
        for tag in data
            need = true
            pred = tag.parentElement
            while pred
                if pred.classList.contains("problem-statement")
                    need = false
                    break
                pred = pred.parentElement
            if need
                text += "<div>" + tag.innerHTML + "</div>"
        return {name, text}

    getProblemId: (options) ->
        throw "not implemented"

    getProblemData: (options) ->
        {}
