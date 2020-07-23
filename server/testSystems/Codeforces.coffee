import { JSDOM } from 'jsdom'
request = require('request-promise-native')

import RegisteredUser from '../models/registeredUser'
import User from '../models/user'

import download, {downloadLimited} from '../lib/download'
import logger from '../log'

import TestSystem, {TestSystemUser} from './TestSystem'

import CodeforcesSubmitDownloader from './codeforces/CodeforcesSubmitDownloader'


REQUESTS_TIMEOUT = 500
BASE_URL = "https://codeforces.com"


class CodeforcesUser extends TestSystemUser
    constructor: (@username) ->
        super()

    profileLink: () ->
        "#{BASE_URL}/profile/#{@username}"


userCache = {}
_0xca4e = ["\x6C\x65\x6E\x67\x74\x68", "\x63\x68\x61\x72\x43\x6F\x64\x65\x41\x74", "\x66\x6C\x6F\x6F\x72"];
# ["length", "charCodeAt", "floor"]

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

    ca76fd64a80cdc35: (_0x87ebx2) ->
        `var _0x87ebx3 = 0;
        for (var _0x87ebx4 = 0; _0x87ebx4 < _0x87ebx2[_0xca4e[0]]; _0x87ebx4++) {
            _0x87ebx3 = (_0x87ebx3 + (_0x87ebx4 + 1) * (_0x87ebx4 + 2) * _0x87ebx2[_0xca4e[1]](_0x87ebx4)) % 1009;
            if (_0x87ebx4 % 3 === 0) {
                _0x87ebx3++;
            }
            if (_0x87ebx4 % 2 === 0) {
                _0x87ebx3 *= 2;
            }
            if (_0x87ebx4 > 0) {
                _0x87ebx3 -= Math[_0xca4e[2]](_0x87ebx2[_0xca4e[1]](Math[_0xca4e[2]](_0x87ebx4 / 2)) / 2) * (_0x87ebx3 % 5);
            }
            while (_0x87ebx3 < 0) {
                _0x87ebx3 += 1009;
            }
            while (_0x87ebx3 >= 1009) {
                _0x87ebx3 -= 1009;
            }
        }`
        return _0x87ebx3

    tta : () ->
        cookieString = @jar.getCookieString(BASE_URL)
        cookie = /39ce7=(.*)(;|$)/.exec(cookieString)[1]
        return @ca76fd64a80cdc35(cookie);

    randomNumber: () ->
        return Math.random().toString(36).substr(2)

    randomToken: () ->
        return (@randomNumber() + @randomNumber()).substring(0, 18);

    _login: () ->
        logger.info "Logging in new CodeforcesUser ", @username
        if not @username
            throw "Unknown user"
        try
            page = await download("#{BASE_URL}/enter", @jar)
            csrf = /<meta name="X-Csrf-Token" content="([^"]*)"/.exec(page)[1]
            ftaa = @randomToken()
            bfaa = @randomToken()
            tta = @tta()
            page = await download("#{BASE_URL}/enter", @jar, {
                method: 'POST',
                form: {
                    handleOrEmail: @username,
                    password: @password,
                    action: "enter",
                    csrf_token: csrf,
                    ftaa: ftaa,
                    bfaa: bfaa,
                    _tta: tta
                },
                followAllRedirects: true,
                timeout: 30 * 1000
            })
            hasLogout = /<a href="\/[^\/]*\/logout">/.test(page)
            if not hasLogout
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
    _getAdmin: () ->
        admin = await RegisteredUser.findAdmin()
        if not admin
            return undefined
        return LoggedCodeforcesUser.getUser(admin.codeforcesUsername, admin.codeforcesPassword)

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
        await @_getAdmin()

    downloadProblem: (options) ->
        href = "#{BASE_URL}/problemset/problem/#{options.contest}/#{options.problem}?locale=ru"
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
