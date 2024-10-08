import { JSDOM } from 'jsdom'
request = require('request-promise-native')
import puppeteer from 'puppeteer-extra'
import StealthPlugin from 'puppeteer-extra-plugin-stealth'
import FormData from 'form-data'
import { Blob } from "buffer";

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

BEFORE_PASS_TIMEOUT = 30 * 1000
LOGIN_TIMEOUT = 1000 * 10

puppeteer.use(StealthPlugin())


class InformaticsUser extends TestSystemUser
    constructor: (@id) ->
        super()

    profileLink: () ->
        "https://informatics.msk.ru/user/view.php?id=#{@id}&course=1"


userCache = {}

PAGE_SCRIPT = """
function getH2() {
    var xpath = "//h2[contains(text(),'you are')]";
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
        r = await page.addScriptTag({content: PAGE_SCRIPT})
        try
            await page.evaluate("needPass()")
            break
        catch
            console.log("Can't add script, retry")
            await sleep(1000)
            if i == 10
                throw new Error("Can't add script")

class LoggedInformaticsUser
    @getUser: (username, password) ->
        key = username + "::" + password
        if userCache[key]
            logger.info "Has user in cache, will wait for login ", username
            try
                await userCache[key]._login()
                logger.info "Has user in cache, done wait for login ", username
                if await userCache[key].getId()
                    return userCache[key]
            catch e
                userCache[key].browser?.close()
                logger.info "Can't use user from cache, relogin", username, e
        logger.info "Creating new InformaticsUser ", username
        newUser = new LoggedInformaticsUser(username, password)
        userCache[key] = newUser
        await newUser._login()
        logger.info "Created new InformaticsUser ", username
        return newUser

    constructor: (@username, @password) ->
        @jar = request.jar()
        @requests = 0
        @promises = []

    _login: () ->
        if @loginPromise
            logger.info("Has loginPromise, will await")
            await @loginPromise
            return
        @loginPromise = new Promise (resolve, reject) => 
            @loginResolve = resolve
            @loginReject = reject
        logger.info "Logging in new InformaticsUser ", @username
        try
            @browser = await puppeteer.launch({
                devtools: true,
                args: [ '--no-sandbox' ],
                headless: false
            })
            @browserWSEndpoint = @browser.wsEndpoint()
            @page = (await @browser.pages())[0]
            #await @page.goto("https://example.org")
            #return
            await sleep(LOGIN_TIMEOUT)
            await @page.goto('https://informatics.msk.ru/login/index.php', {timeout: 120 * 1000})
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
            console.log("Passed")
            content = await @page.content()
            token = /<input type="hidden" name="logintoken" value="([^"]*)">/.exec(content)?[1]
            await sleep(LOGIN_TIMEOUT)
            page = await @download("https://informatics.msk.ru/login/index.php", {
                method: 'POST',
                form: {
                    username: @username,
                    password: @password,
                    logintoken: token
                },
                followAllRedirects: true,
                timeout: 120 * 1000
            })
            if page.includes("Неверный логин или пароль")
                throw { badPassword: true }
            @id = await @getId()
            if not @id
                throw "Can not log user #{@username} in"
            logger.info "Logged in new InformaticsUser ", @username
            @loginResolve()
        catch e
            @browser?.close()
            if e.badPassword
                throw e
            logger.error "Can not log in new Informatics user #{@username}", e.message, e
            @loginReject(e)
            throw e
        logger.info "Done _login"

    getId: () ->
        await sleep(LOGIN_TIMEOUT)
        page = await @download("https://informatics.msk.ru/")
        @name = /<span class="userbutton"><span class="usertext mr-1">([^<]*)</.exec(page)?[1]
        id = /<a href="https:\/\/informatics.msk.ru\/user\/profile.php\?id=(\d+)"/.exec(page)?[1]
        if not @name or not id or id.length < 2
            return null
        return id[1]

    download: (href, options={}) ->
        if _requests >= REQUESTS_LIMIT
            await new Promise((resolve) => _promises.push(resolve))
        if _requests >= REQUESTS_LIMIT
            throw "Too many requests"
        _requests++
        await sleep(TIMEOUT)
        options.timeout = options.timeout || 60 * 1000
        try
            fetchOptions = {
                method: options.method
                headers: options.headers || {}
            }
            preFetch = ""
            if options.form
                fetchOptions.body = (new URLSearchParams(options.form)).toString()
                fetchOptions.headers["Content-Type"] = "application/x-www-form-urlencoded"
            if options.formData
                fd = new FormData()
                console.log(options.formData)
                for key of options.formData
                    value = options.formData[key]
                    console.log(key, value)
                    if !value.value
                        fd.append(key, value)
                    else
                        fd.append(key, value.value, value.options)
                bodyBuffer = Array.from(fd.getBuffer())
                preFetch = """
                    body = #{JSON.stringify(bodyBuffer)}
                    options.body = new Uint8Array(body)
                """
                fetchOptions.headers = {fetchOptions.headers..., fd.getHeaders()...}
            code = """
                (async function(){ 
                    options = #{JSON.stringify(fetchOptions)}
                    #{preFetch}
                    return await (await fetch('#{href}', options)).text() 
                })()
            """
            console.log(code)
            result = await @page.evaluate(code)
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
        member = await @getMemberFromTeam(registeredUser)
        realUserId = registeredUser.informaticsId
        userId = member.informaticsId
        problemId = @_informaticsProblemId(problem._id)
        groupId = 0
        fromTimestamp = 0
        user = await @_getAdmin()
        admin = true
        if not user
            user = await LoggedInformaticsUser.getUser(member.informaticsUsername, member.informaticsPassword)
            admin = false
        url = (page) ->
            "#{BASE_URL}/py/problem/#{problemId}/filter-runs?problem_id=#{problemId}&from_timestamp=-1&to_timestamp=-1&group_id=#{groupId}&user_id=#{userId}&lang_id=-1&status_id=-1&statement_id=0&count=#{submitsPerPage}&with_comment=&page=#{page + 1}"
        return new InformaticsSubmitDownloader(user, url, admin, userId, realUserId)

    submitNeedsFormData: () ->
        true

    getMemberFromTeam: (registeredUser) ->
        if registeredUser.informaticsUsername
            return registeredUser
        fullUser = await User.findById(registeredUser.userKey())
        for m in fullUser.members
            member = await RegisteredUser.findByKeyWithPassword(m)
            if member?.informaticsUsername
                return member
        throw "Can't find user with required data"

    submitWithObject: (user, problemId, data) ->
        informaticsProblemId = @_informaticsProblemId(problemId)
        logger.info "Try submit #{user.username}, #{user.informaticsId} #{problemId}"
        member = await @getMemberFromTeam(user)
        informaticsUser = await LoggedInformaticsUser.getUser(member.informaticsUsername, member.informaticsPassword)
        await informaticsUser.submitWithObject(informaticsProblemId, data)

    registerUser: (user) ->
        

    selfTest: () ->
        await @_getAdmin()

    downloadProblem: (options, label) ->
        if label != ""
            return 
                name: "Name #{options.id}"
                text: "Text #{options.id}"
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
