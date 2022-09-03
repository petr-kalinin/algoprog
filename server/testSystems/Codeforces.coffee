import { JSDOM } from 'jsdom'
request = require('request-promise-native')

import CodeforcesSubmitDownloader from './codeforces/CodeforcesSubmitDownloader'
import slowAES from './codeforces/aes.min'
import TestSystem, {TestSystemUser} from './TestSystem'

import download, {downloadLimited} from '../lib/download'
import sleep from '../lib/sleep'
import {notify, notifyDocument} from '../lib/telegramBot'

import logger from '../log'

import RegisteredUser from '../models/registeredUser'
import User from '../models/user'


TIMEOUT = 250
REQUESTS_LIMIT = 1
BASE_URL = "https://codeforces.com"


class CodeforcesUser extends TestSystemUser
    constructor: (@username) ->
        super()

    profileLink: () ->
        "#{BASE_URL}/profile/#{@username}"


userCache = {}
_0xca4e = ["\x6C\x65\x6E\x67\x74\x68", "\x63\x68\x61\x72\x43\x6F\x64\x65\x41\x74", "\x66\x6C\x6F\x6F\x72"];
# ["length", "charCodeAt", "floor"]

_toNumbers = (d) ->
    e=[]
    d.replace(/(..)/g, (d) -> e.push(parseInt(d,16)))
    return e
    
_toHex = () -> 
    `for(var d=[],d=1==arguments.length&&arguments[0].constructor==Array?arguments[0]:arguments,e="",f=0;f<d.length;f++)
        e+=(16>d[f]?"0":"")+d[f].toString(16);
    `
    return e.toLowerCase()
    
getRCPC = (page) ->
    console.log "page=", page
    a = /a=toNumbers\("([^"]*)"\)/.exec(page)[1]
    b = /b=toNumbers\("([^"]*)"\)/.exec(page)[1]
    c = /c=toNumbers\("([^"]*)"\)/.exec(page)[1]
    console.log "abc=", a, b, c
    return _toHex(slowAES.decrypt(_toNumbers(c),2,_toNumbers(a),_toNumbers(b)))

export class LoggedCodeforcesUser
    @getUser: (username, password) ->
        key = username + "::" + password
        if not userCache[key] or (new Date() - userCache[key].loginTime > 1000 * 60 * 60 * 5)
            logger.info "Creating new CodeforcesUser ", username
            newUser = new LoggedCodeforcesUser(username, password)
            await newUser._login()
            userCache[key] =
                user: newUser
                loginTime: new Date()
            logger.info "Created new CodeforcesUser ", username
        return userCache[key].user

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

    _getCsrf: (page) ->
        return /<meta name="X-Csrf-Token" content="([^"]*)"/.exec(page)[1]    

    _login: () ->
        logger.info "Logging in new CodeforcesUser ", @username
        if not @username
            throw "Unknown user"
        try
            page = await @download("#{BASE_URL}/enter")
            if page.includes("Redirecting... Please, wait.")
                RCPC = getRCPC(page)
                console.log "RCPC", RCPC
                @jar.setCookie("RCPC=#{RCPC}", BASE_URL)
                logger.info "Cf pre-login cookie=", @jar.getCookieString(BASE_URL)
                page = await @download("#{BASE_URL}/enter?f0a28=1")
            csrf = @_getCsrf(page)
            @ftaa = @randomToken()
            @bfaa = @randomToken()
            tta = @tta()
            page = await @download("#{BASE_URL}/enter", {
                method: 'POST',
                form: {
                    handleOrEmail: @username,
                    password: @password,
                    action: "enter",
                    csrf_token: csrf,
                    ftaa: @ftaa,
                    bfaa: @bfaa,
                    _tta: tta
                },
                followAllRedirects: true,
                timeout: 30 * 1000
            })
            if page.includes("Некорректный хэндл/email или пароль") or page.includes("Invalid handle/email or password")
                throw {badPassword: true}
            @handle = /<a href="\/profile\/([^"]*)">[^<]*<\/a>\s*|\s*<a href="\/[^"]*\/logout">/.exec(page)?[1]
            if not @handle
                throw "Can not log user #{@username} in"
            logger.info "Logged in new CodeforcesUser ", @username, @handle
        catch e
            logger.error "Can not log in new Codeforces user #{@username}", e.message, e
            throw e

    download: (href, options) ->
        if @requests >= REQUESTS_LIMIT
            await new Promise((resolve) => @promises.push(resolve))
        if @requests >= REQUESTS_LIMIT
            throw "Too many requests"
        @requests++
        await sleep(TIMEOUT)
        if not options
            options = {}
        options.maxAttempts = 1
        options.timeout = 30 * 1000
        try
            result = await download(href, @jar, options)
        finally
            @requests--
            if @promises.length
                promise = @promises.shift()
                promise(0)  # resolve
        return result

    submit: (problemId, contentType, body) ->
        throw "Not implemented"

    submitWithObject: (problemId, data) ->
        {contest, problem} = data.testSystemData
        if contest.startsWith("gym")
            href = "#{BASE_URL}/#{contest}/submit"
            csrfHref = "#{BASE_URL}/#{contest}"
        else
            href = "#{BASE_URL}/problemset/problem/#{contest}/#{problem}"
            csrfHref = href
        page = await @download(csrfHref)
        csrf = @_getCsrf(page)
        logger.info "Found csrf=#{csrf}"
        href = href + "?csrf_token=#{csrf}"
        tta = @tta()
        data = {
                csrf_token: csrf
                ftaa: @ftaa
                bfaa: @bfaa
                _tta: tta
                action: "submitSolutionFormSubmitted"
                submittedProblemIndex: problem
                programTypeId: data.language
                sourceFile: {
                    value: Buffer.from(data.source, "latin1")
                    options: {
                        filename: 'a',
                        contentType: 'text/plain'
                    }
                }
            }

        page = await @download(href, {
            formData: data,
            method: 'POST',
            followAllRedirects: true,
            timeout: 30 * 1000
        })
        if page.includes("You have submitted exactly the same code before")
            logger.info "Submit is a duplicate"
            throw {duplicate: true}
        if not page.includes("Contest status")
            notify "Can't submit to CF"
            notifyDocument page
            logger.error "Can't submit"
            throw "Can't submit"
        logger.info "Apparently submitted!"


export default class Codeforces extends TestSystem
    _getAdmin: () ->
        admin = await RegisteredUser.findAdmin()
        if not admin
            return undefined
        return LoggedCodeforcesUser.getUser(admin.codeforcesUsername, admin.codeforcesPassword)

    id: () ->
        return "codeforces"

    submitDownloader: (registeredUser, problem, submitsPerPage) ->
        member = await @getMemberFromTeam(registeredUser)
        username = member.codeforcesUsername
        contest = problem.testSystemData.contest
        cproblem = problem.testSystemData.problem
        loggedUser = await LoggedCodeforcesUser.getUser(member.codeforcesUsername, member.codeforcesPassword)
        return new CodeforcesSubmitDownloader(BASE_URL, username, contest, cproblem, registeredUser.userKey(), problem._id, loggedUser)

    submitNeedsFormData: () ->
        false

    getMemberFromTeam: (registeredUser) ->
        if registeredUser.codeforcesUsername
            return registeredUser
        fullUser = await User.findById(registeredUser.userKey())
        for m in fullUser.members
            member = await RegisteredUser.findByKeyWithPassword(m)
            if member?.codeforcesUsername
                return member
        throw "Can't find user with required data"

    submitWithObject: (registeredUser, problemId, data) ->
        member = await @getMemberFromTeam(registeredUser)
        {contest, problem} = data.testSystemData
        logger.info "Try submit #{registeredUser.username}, #{registeredUser.userKey()} #{member.codeforcesUsername} #{problemId} #{contest} #{problem}"
        if not member.codeforcesUsername
            throw "No codeforces username given"
        codeforcesUser = await LoggedCodeforcesUser.getUser(member.codeforcesUsername, member.codeforcesPassword)
        await codeforcesUser.submitWithObject(problem, data)

    registerUser: (user) ->
        logger.info "Do nothing to register user in codeforces"

    selfTest: () ->
        await @_getAdmin()

    downloadProblem: (options, label) ->
        locale = 
            if label == "" then "ru"
            else if label == "!en" then "en"
            else throw "Don't know locale for label #{label}"
        if options.contest.startsWith("gym")
            href = "#{BASE_URL}/#{options.contest}/problem/#{options.problem}?locale=#{locale}"
        else
            href = "#{BASE_URL}/problemset/problem/#{options.contest}/#{options.problem}?locale=#{locale}"
        page = await downloadLimited(href, {timeout: 15 * 1000})
        if page.includes("Redirecting... Please, wait.")
            jar = request.jar()
            RCPC = getRCPC(page)
            console.log "RCPC", RCPC
            jar.setCookie("RCPC=#{RCPC}", BASE_URL)
            logger.info "Cf pre-login cookie=", jar.getCookieString(BASE_URL)
            page = await download("#{href}&f0a28=1", jar)
        document = (new JSDOM(page, {url: href})).window.document
        data = document.getElementsByClassName("problem-statement")
        console.log(page)
        if not data or data.length == 0
            logger.warn("Can't find statement for problem " + href)
            seeCfStatement = 
                if label == "" then "См. условие на codeforces"
                else if label == "!en" then "See statement on codeforces"
            name = options.name || "???"
            text = "<h1>#{name}</h1> <div>#{seeCfStatement}:</div>"
            return {name, text}
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
        contest = options.contest.replace("/", "")
        return "c#{contest}p#{options.problem}"

    getProblemData: (options) ->
        {
            contest: options.contest
            problem: options.problem
        }
