request = require('request-promise-native')
import { JSDOM } from 'jsdom'

import {downloadLimited} from '../lib/download'
import logger from '../log'

import TestSystem, {TestSystemUser} from './TestSystem'

import RegisteredUser from '../models/registeredUser'


REQUESTS_LIMIT = 20


userCache = {}

class LoggedEjudgeUser
    @getUser: (server, contestId, username, password) ->
        key = "#{server}::#{contestId}::#{username}::#{password}"
        if not userCache[key] or (new Date() - userCache[key].loginTime > 1000 * 60 * 60)
            logger.info "Creating new EjudgeUser ", username, contestId
            newUser = new LoggedEjudgeUser(server, contestId, username, password)
            await newUser._login()
            userCache[key] =
                user: newUser
                loginTime: new Date()
        return userCache[key].user

    constructor: (@server, @contestId, @username, @password) ->
        @jar = request.jar()
        @requests = 0
        @promises = []
        @sid = {}

    _login: () ->
        await @_loginToProg("new-client")
        await @_loginToProg("serve-control")
        logger.info "Logged in user #{@username}, sid=#{@sid}"

    _loginToProg: (prog) ->
        page = await downloadLimited("#{@server}/cgi-bin/#{prog}", @jar, {
            method: 'POST',
            form: {
                login: @username,
                password: @password,
                contest_id: @contestId
            },
            followAllRedirects: true,
            timeout: 30 * 1000
        })
        if not page.includes("Logout")
            console.log page
            throw "Can't log user #{@username} in"
        sidString = page.match(/SID=([0-9a-f]+)/)
        @sid[prog] = sidString[1]

    download: (href, options, prog="new-client") ->
        if @sid["prog"]
            if not href.includes('?')
                href = href + "?"
            href = href + "&SID=#{@sid['prog']}"
        result = await downloadLimited(href, @jar, options)
        return result


export default class Ejudge extends TestSystem
    constructor: (@server, @baseContest) ->
        super()

    id: () ->
        return "ejudge"

    getAdmin: (contestId) ->
        admin = await RegisteredUser.findAdmin()
        return LoggedEjudgeUser.getUser(@server, contestId, admin.ejudgeUsername, admin.ejudgePassword)

    registerUser: (user, registeredUser, password) ->
        adminUser = await @getAdmin(@baseContest)

        registeredUser.ejudgePassword = password

        href = "#{@server}/cgi-bin/serve-control"
        form =
            SID: adminUser.sid["serve-control"]
            contest_id: @baseContest
            group_id: ""
            other_login: registeredUser.ejudgeUsername
            other_email: ""
            reg_password1: registeredUser.ejudgePassword
            reg_password2: registeredUser.ejudgePassword
            reg_random: ""
            field_9: 1
            reg_cnts_create: 1
            other_contest_id_1: @baseContest
            other_contest_id_2: @baseContest
            cnts_status: 0
            cnts_password1: ""
            cnts_password2: ""
            cnts_random: ""
            cnts_name: ""
            other_group_id: ""
            action_73: "Create a user"

        res = await adminUser.download(href, {
            method: 'POST',
            headers: {'Content-Type': "application/x-www-form-urlencoded"},
            form: form,
            followAllRedirects: true
        }, "serve-control")

    parseProblem: (admin, problemHref) ->
        page = await admin.download(problemHref)
        document = (new JSDOM(page, {url: problemHref})).window.document
        el = document.getElementById("probNavTaskArea-ins")
        for tag in ["h2", "form"]
            subels = el.getElementsByTagName(tag)
            for subel in subels
                subel.parentElement.removeChild(subel)
        headers = el.getElementsByTagName("h3")
        submitHeader = headers[headers.length - 1]
        submitHeader.parentElement.removeChild(submitHeader)
        header = headers[0]
        return {
            name: header.innerHTML
            text: el.innerHTML
        }

    downloadContestProblems: (contestId) ->
        admin = await @getAdmin(contestId)
        href = "#{@server}/cgi-bin/new-client"
        page = await admin.download(href)
        document = (new JSDOM(page, {url: href})).window.document
        tab = document.getElementById("probNavTopList")
        problemElements = tab.getElementsByClassName("tab")
        result = []
        for el in problemElements
            probHref = el.href
            id = el.innerHTML
            problem = await @parseProblem(admin, probHref)
            problem._id = "p#{contestId}p#{id}"
            problem.letter = id
            result.push(problem)
            logger.info "Found problem ", problem
        return result


