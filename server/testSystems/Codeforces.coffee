moment = require('moment')
import fs from 'fs/promises'
import { JSDOM } from 'jsdom'
import puppeteer from 'puppeteer-extra'
import StealthPlugin from 'puppeteer-extra-plugin-stealth'
request = require('request-promise-native')
import { Mutex } from 'async-mutex'

import CodeforcesSubmitDownloader from './codeforces/CodeforcesSubmitDownloader'
import {checkOutcome} from './TestSystem'
import slowAES from './codeforces/aes.min'
import TestSystem, {TestSystemUser} from './TestSystem'

import download, {downloadLimited} from '../lib/download'
import sleep from '../lib/sleep'
import {notify, notifyDocument} from '../lib/telegramBot'

import logger from '../log'

import RegisteredUser from '../models/registeredUser'
import User from '../models/user'
import Submit from '../models/submit'


TIMEOUT = 250
REQUESTS_LIMIT = 1
BASE_URL = "https://codeforces.com"

puppeteer.use(StealthPlugin())

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
    #console.log "page=", page
    a = /a=toNumbers\("([^"]*)"\)/.exec(page)[1]
    b = /b=toNumbers\("([^"]*)"\)/.exec(page)[1]
    c = /c=toNumbers\("([^"]*)"\)/.exec(page)[1]
    #console.log "abc=", a, b, c
    return _toHex(slowAES.decrypt(_toNumbers(c),2,_toNumbers(a),_toNumbers(b)))

BEFORE_PASS_TIMEOUT = 20 * 1000

PAGE_SCRIPT = """
function getH2() {
    var xpath = "//p[contains(text(),'Verify you are')]";
    return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}
function needPass() {
    return !!getH2()
}
function addFakeCheckboxAndClick() {
    getH2().insertAdjacentHTML('afterend', '<input type="text" id="foobar"/>')
    document.getElementById("foobar").click()
    document.getElementById("foobar").focus()
}
"""

addScipt = (page) ->
    i = 0
    while true
        i++
        r = await page.evaluate(PAGE_SCRIPT)
        console.log(r)
        try
            await page.evaluate("needPass()")
            break
        catch
            console.log("Can't add script, retry")
            await sleep(1000)
            if i == 10
                throw new Error("Can't add script")

export class LoggedCodeforcesUser
    @getUser: (username, password) ->
        key = username + "::" + password
        if not userCache[key] or (new Date() - userCache[key].loginTime > 1000 * 60 * 60)
            if userCache[key]?.browser
                userCache[key]?.browser.close()
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
        @mutex = new Mutex()

###
    runExclusive: (fn) ->
        if @pageRunning
            console.log("Page already used, will wait")
            promise = new Promise((resolve) => @pageQueue.push(resolve))
            await promise
            console.log("Page already used, done wait")
        if @pageRunning
            throw new Error("Wrong mutex login in cf")
        console.log("Page free!")
        @pageRunning = true
        try
            await fn()
        finally
            console.log("Done page running")
            @pageRunning = false
            if @pageQueue.length
                resolve = @pageQueue.shift()
                resolve()
###

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

    _loginImpl: () ->
        logger.info "Logging in new CodeforcesUser ", @username
        if not @username
            throw "Unknown user"
        try
            @browser = await puppeteer.launch({
                devtools: true,
                args: [ '--no-sandbox' ],
                headless: 'new'
            })
            @browserWSEndpoint = @browser.wsEndpoint()
            @page = (await @browser.pages())[0]
            await @page.goto("#{BASE_URL}/enter")
            console.log("Will disconnect and sleep")
            await @browser.disconnect()
            await sleep(BEFORE_PASS_TIMEOUT)
            console.log("Will reconnect and check")
            @browser = await puppeteer.connect({ browserWSEndpoint: @browserWSEndpoint })
            @page = (await @browser.pages())[0]
            await addScipt(@page)
            while (await @page.evaluate("needPass()"))
                console.log("Need pass")
                await @page.evaluate('addFakeCheckboxAndClick()')
                await @page.type("#foobar", "aa")
                await sleep(100)
                await @page.keyboard.press('Tab')
                await sleep(100)
                await @page.keyboard.press('Space')
                console.log("Done click")
                console.log("Will disconnect and sleep")
                await @browser.disconnect()
                await sleep(BEFORE_PASS_TIMEOUT)
                console.log("Will reconnect and check")
                @browser = await puppeteer.connect({ browserWSEndpoint: @browserWSEndpoint })
                @page = (await @browser.pages())[0]
                await addScipt(@page)
            await @page.type("#handleOrEmail", @username)
            console.log("---4 #{@username}")
            await @page.type("#password", @password)
            console.log("---5 #{@username}")
            promise = @page.waitForNavigation()
            console.log("---6 #{@username}")
            await @page.click(".submit")
            console.log("---7 #{@username}")
            #console.log("Done click")
            await promise
            console.log("---8 #{@username}")
            cookies = await @page.cookies()
            console.log("---9 #{@username}")
            for cookie in cookies
                @jar.setCookie("#{cookie.name}=#{cookie.value}", BASE_URL)
            #console.log("Cookies in jar:", @jar.getCookieString(BASE_URL))
            ###
            csrf = await ppage.evaluate("document.getElementsByName('X-Csrf-Token')[0].getAttribute('content')")
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
            ###
            content = await @page.content()
            console.log("---10 #{@username}")
            if content.includes("Некорректный хэндл/email или пароль") or content.includes("Invalid handle/email or password")
                throw {badPassword: true}
            console.log("---11 #{@username}")
            @handle = /<a href="\/profile\/([^"]*)">[^<]*<\/a>\s*|\s*<a href="\/[^"]*\/logout">/.exec(content)?[1]
            console.log("---12 #{@username}")
            if not @handle
                notifyDocument content, {filename: 'page.html', contentType: "text/html"}
                throw "Can not log user #{@username} in: no handle in response"
            logger.info "Logged in new CodeforcesUser ", @username, @handle
        catch e
            logger.error "Can not log in new Codeforces user #{@username}", e.message, e
            notify "Can not log in new Codeforces user #{@username}"
            notifyDocument(await @page.content(), {filename: 'page.html', contentType: "text/html"})
            throw e

    _login: () ->
        #console.log("login: before mutex")
        await @mutex.runExclusive(@_loginImpl.bind(this))
        #console.log("login: after  mutex")

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

    submitWithObjectImpl: (problemId, data) ->
        {contest, problem} = data.testSystemData
        isGym = contest.startsWith("gym")
        if isGym
            href = "#{BASE_URL}/#{contest}/submit"
            csrfHref = "#{BASE_URL}/#{contest}"
        else
            href = "#{BASE_URL}/problemset/problem/#{contest}/#{problem}"
            csrfHref = href
        #console.log("Will go to #{href}")
        ###
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
        ###
        await @page.goto(href)

        #console.log("Will upload file")
        inputUploadHandle = await @page.$('input[type=file]')
        if not inputUploadHandle
            throw new Error("No file upload!!!")
        path = "/tmp/sources"
        await fs.mkdir(path, { recursive: true })
        fileToUpload = "#{path}/#{Math.random().toString(36).substr(2)}"
        await fs.writeFile(fileToUpload, Buffer.from(data.source, "latin1"))
        inputUploadHandle.uploadFile(fileToUpload)
        await @page.evaluate("document.getElementsByName('programTypeId')[0].value = '#{data.language}'")
        if isGym
            await @page.evaluate("document.getElementsByName('submittedProblemIndex')[0].value = '#{problem}'")
        promise = @page.waitForNavigation()
        await @page.click(".submit")
        await promise
        content = await @page.content()
        if content.includes("You have submitted exactly the same code before")
            logger.info "Submit is a duplicate"
            throw {duplicate: true}
        if content.includes("the programming language of these submissions differs from the selected language")
            logger.info "The programming language of these submissions differs from the selected language"
            throw {contactMe: true}
        if not content.includes("Contest status") and not content.includes("My Submissions")
            notify "Can't submit to CF"
            notifyDocument content, {filename: 'page.html', contentType: "text/html"}
            logger.error "Can't submit"
            throw "Can't submit"
        logger.info "Apparently submitted!"

    submitWithObject: (problemId, data) ->
        #console.log("submitWithObject: before mutex")
        await @mutex.runExclusive(() => await @submitWithObjectImpl(problemId, data))
        #console.log("submitWithObject: after mutex")
    
    _getSourceAndResultsImpl: (runid) ->
        logger.info "Will download source and results for #{runid}"
        await @page.goto("#{BASE_URL}/submissions/#{@username}")
        csrf = @_getCsrf(await @page.content())
        formData = new URLSearchParams({
            csrf_token: csrf,
            submissionId: runid
        })
        code = "(async () => await (await fetch('#{BASE_URL}/data/submitSource', {
            'headers': {
                'cache-control': 'no-cache',
                'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'pragma': 'no-cache',
                'x-csrf-token': '#{csrf}',
                'x-requested-with': 'XMLHttpRequest'
            },
            'referrer': '#{BASE_URL}/submissions/#{@username}',
            'body': '#{formData.toString()}',
            'method': 'POST',
            'mode': 'cors',
            'credentials': 'include'
        })).json())()"
        #console.log(code)
        data = await @page.evaluate(code)
        ###
        data.protocol = await @loggedUser.download "#{@baseUrl}/data/judgeProtocol", postData
        data.protocol = JSON.parse(data.protocol)
        ###
        #console.log(data)
        return data

    _getSourceAndResults: (runid) ->
        #console.log("_getSourceAndResults: before mutex")
        result = await @mutex.runExclusive(() => await @_getSourceAndResultsImpl(runid))
        #console.log("_getSourceAndResults: after mutex")
        return result

    getSubmitsFromGymImpl: (contest, problem, realUser, realProblem, correctOutcome) ->
        url = "#{BASE_URL}/#{contest}/my"
        logger.info("Will get submits from gym, url=#{url}")
        await @page.goto(url)
        content = await @page.content()
        document = (new JSDOM(content, {url: url})).window.document
        table = document.getElementsByClassName("status-frame-datatable")[0]
        els = Array.from(table?.getElementsByTagName("tr"))
        result = []
        baseProbHref = "#{BASE_URL}/#{contest}/problem/"
        count = 0
        for el in els
            id = el.children[0]?.textContent?.trim()
            time = el.children[1]?.textContent?.trim()
            user = el.children[2]?.textContent?.trim()
            prob = el.children[3]?.getElementsByTagName("a")[0]?.href?.trim()
            lang = el.children[4]?.textContent?.trim()
            outcome = el.children[5]?.textContent?.trim()
            if (!prob || !prob.startsWith(baseProbHref))
                logger.info "Ignoring problem ", prob
                continue
            count += 1
            prob = prob.substring(baseProbHref.length)
            time = moment(time, "MMM/DD/YYYY HH:mm", true).subtract(3, 'hours').toDate()
            if outcome == "In queue" or outcome.startsWith("Running")
                outcome = "CT"
            if outcome == "Compilation error"
                outcome = "CE"
            if outcome == "Вы уже отправляли этот код"
                outcome = "DP"
            if outcome == "Accepted"
                outcome = "OK"
            if user.toLowerCase() != @username.toLowerCase()
                throw "Strange submit: found username  #{user}, expected #{@username}"
            if prob != problem
                logger.info "Skipping submit #{id} because it is for a different problem: #{prob} vs #{problem}"
                continue
            outcome = correctOutcome(outcome)
            console.log "found id=#{id}, time=#{time}, user=#{user}, prob=#{prob}, lang=#{lang}, outcome=#{outcome}"
            result.push new Submit(
                _id: "c" + id,
                time: time
                user: realUser
                problem: realProblem
                outcome: outcome
                language: lang
                testSystemData: 
                    runId: id
                    contest: contest
                    problem: problem
                    system: "codeforces"
                    username: @username
            )
            checkOutcome(outcome)
        if count == 0
            notify "No submits found in CF table"
            notifyDocument content, {filename: 'page.html', contentType: "text/html"}
        return result

    getSubmitsFromGym: (contest, problem, realUser, realProblem, correctOutcome) ->
        #console.log("getSubmitsFromGym: before mutex")
        result = await @mutex.runExclusive((() => await @getSubmitsFromGymImpl(contest, problem, realUser, realProblem, correctOutcome)).bind(this))
        #console.log("getSubmitsFromGym: after mutex")
        return result
    

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
            #console.log "RCPC", RCPC
            jar.setCookie("RCPC=#{RCPC}", BASE_URL)
            logger.info "Cf pre-login cookie=", jar.getCookieString(BASE_URL)
            page = await download("#{href}&f0a28=1", jar)
        document = (new JSDOM(page, {url: href})).window.document
        data = document.getElementsByClassName("problem-statement")
        #console.log(page)
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
