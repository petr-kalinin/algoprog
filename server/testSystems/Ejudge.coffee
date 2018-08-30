request = require('request-promise-native')

import download from '../lib/download'
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

    _login: () ->
        page = await download("#{@server}/cgi-bin/new-client", @jar, {
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


export default class Ejudge extends TestSystem
    constructor: (@server) ->
        super()

    id: () ->
        return "ejudge"

    getAdmin: (contestId) ->
        admin = await RegisteredUser.findAdmin()
        return LoggedEjudgeUser.getUser(@server, contestId, admin.ejudgeUsername, admin.ejudgePassword)


