import { JSDOM } from 'jsdom'
request = require('request-promise-native')

import RegisteredUser from '../models/registeredUser'
import User from '../models/user'

import download, {downloadLimited} from '../lib/download'
import logger from '../log'

import TestSystem, {TestSystemUser} from './TestSystem'

import CodeforcesSubmitDownloader from './codeforces/CodeforcesSubmitDownloader'


REQUESTS_TIMEOUT = 500


class CodeforcesUser extends TestSystemUser
    constructor: (@username) ->
        super()

    profileLink: () ->
        "http://codeforces.com/profile/#{@username}"


userCache = {}

class LoggedCodeforcesUser
    @getUser: (username, password) ->
        key = username + "::" + password
        if not userCache[key] or not (await userCache[key].getId())
            logger.info "Creating new CodeforcesUser ", username
            newUser = new LoggedCodeforcesUser(username, password)
            await newUser._login()
            userCache[key] = newUser
            logger.info "Created new CodeforcesUser ", username
        return userCache[key]

    constructor: (@username, @password) ->
        @jar = request.jar()
        @requests = 0
        @promises = []

    _login: () ->
        logger.info "Logging in new CodeforcesUser ", @username
        try
            page = await download("http://codeforces.com/enter", @jar)
            console.log "Page=", page
            csrf = /<meta name="X-Csrf-Token" content="([^"]*)"/.exec(page)[1]
            console.log "Found csrf token=", csrf
            ftaa = /window._ftaa = "([^"])*"/.exec(page)[1]
            console.log "Found ftaa=", csrf
            bfaa = /window._bfaa = "([^"])*"/.exec(page)[1]
            console.log "Found bfaa=", csrf
            throw "Now implemented"
            page = await download("https://codeforces.msk.ru/login/index.php", @jar, {
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
            logger.info "Logged in new CodeforcesUser ", @username
        catch e
            logger.error "Can not log in new Codeforces user #{@username}", e.message, e

    download: (href, options) ->
        throw "Needs fix"
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
        throw "Needs fix"
        page = await download("https://codeforces.msk.ru/py/problem/#{problemId}/submit", @jar, {
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
        throw "Needs fix"
        @_runSubmit(problemId, {
            headers: {'Content-Type': contentType},
            body,
        })

    submitWithObject: (problemId, data) ->
        throw "Needs fix"
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

export default class Codeforces extends TestSystem
    BASE_URL = "https://codeforces.com"

    _getAdmin: () ->
        admin = await RegisteredUser.findAdmin()
        if not admin
            return undefined
        return LoggedCodeforcesUser.getUser(admin.codeforcesLogin, admin.codeforcesPassword)

    id: () ->
        return "codeforces"

    submitDownloader: (registeredUser, problem, submitsPerPage) ->
        throw "Now implemented"
        userId = registeredUser.codeforcesId
        problemId = @_codeforcesProblemId(problem._id)
        groupId = 0
        fromTimestamp = 0
        user = await @_getAdmin()
        admin = true
        if not user
            user = await LoggedCodeforcesUser.getUser(registeredUser.codeforcesUsername, registeredUser.codeforcesPassword)
            admin = false
        url = (page) ->
            "#{BASE_URL}/py/problem/#{problemId}/filter-runs?problem_id=#{problemId}&from_timestamp=-1&to_timestamp=-1&group_id=#{groupId}&user_id=#{userId}&lang_id=-1&status_id=-1&statement_id=0&count=#{submitsPerPage}&with_comment=&page=#{page}"
        return new CodeforcesSubmitDownloader(user, url, admin)

    submitNeedsFormData: () ->
        false

    submitWithObject: (user, problemId, data) ->
        throw "Now implemented"
        codeforcesProblemId = @_codeforcesProblemId(problemId)
        logger.info "Try submit #{user.username}, #{user.codeforcesId} #{problemId}"
        codeforcesUser = await LoggedCodeforcesUser.getUser(user.codeforcesUsername, user.codeforcesPassword)
        await codeforcesUser.submitWithObject(codeforcesProblemId, data)

    registerUser: (user) ->
        logger.info "Do nothing to register user in codeforces"

    selfTest: () ->
        #await @_getAdmin()

    downloadProblem: (options) ->
        href = "https://codeforces.com/problemset/problem/#{options.contest}/#{options.problem}?locale=ru"
        page = await downloadLimited(href, {timeout: 15 * 1000})
        document = (new JSDOM(page, {url: href})).window.document
        data = document.getElementsByClassName("problem-statement")
        if not data or data.length == 0
            logger.warn("Can't find statement for problem " + href)
            return {"???", "???"}
        data = data[0]
        nameEl = data.getElementsByClassName("title")[0]
        # Drop leading letter, dot and space
        name = nameEl?.innerHTML.substring(3)
        nameEl?.parentElement.removeChild(nameEl)

        if not name
            logger.warn Error("Can't find name for problem " + href)
            name = "???"

        text = "<h1>" + name + "</h1>"
        text += "<div class='codeforces-statement'>#{data.innerHTML}</div>"
        text = text.replace(/\$\$\$/g, "$")
        return {name, text}

    getProblemId: (options) ->
        return "c#{options.contest}p#{options.problem}"

    getProblemData: (options) ->
        {
            contest: options.contest
            problem: options.problem
        }
