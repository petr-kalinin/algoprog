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
        @sid = undefined

    _login: () ->
        page = await downloadLimited("#{@server}/cgi-bin/new-client", @jar, {
            method: 'POST',
            form: {
                login: @username,
                password: @password,
                contest_id: @contestId
            },
            followAllRedirects: true,
            timeout: 30 * 1000
        })
        if not page.includes("Logout [")
            console.log page
            throw "Can't log user #{@username} in"
        sidString = page.match(/SID=([0-9a-f]+)/)
        @sid = sidString[1]
        logger.info "Logged in user #{@username}, sid=#{@sid}"

    download: (href, options) ->
        if @sid
            if not href.includes('?')
                href = href + "?"
            href = href + "&SID=#{@sid}"
        result = await downloadLimited(href, @jar, options)
        return result


export default class Ejudge extends TestSystem
    constructor: (@server) ->
        super()

    id: () ->
        return "ejudge"

    getAdmin: (contestId) ->
        admin = await RegisteredUser.findAdmin()
        return LoggedEjudgeUser.getUser(@server, contestId, admin.ejudgeUsername, admin.ejudgePassword)

    parseProblem: (admin, problemHref) ->
        page = await admin.download(problemHref)
        document = (new JSDOM(page, {url: problemHref})).window.document
        el = document.getElementById("probNavTaskArea-ins")
        for tag in ["h2", "form"]
            subels = el.getElementsByTagName(tag)
            for subel in subels
                subel.parentElement.removeChild(subel)
        header = el.getElementsByTagName("h3")[0]
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


