import { JSDOM } from 'jsdom'
request = require('request-promise-native')

import RegisteredUser from '../models/registeredUser'

import download from '../lib/download'

import logger from '../log'

import {getClassStartingFromJuly} from '../../client/lib/graduateYearToClass'

# this will give some mistake due to leap years, but we will neglect it
MS_PER_YEAR = 1000 * 60 * 60 * 24 * 365.25
REQUESTS_LIMIT = 20

getCurrentYearStart = () ->
    baseDate = new Date(1990, 6, 1)
    now = new Date()
    baseTime = now - baseDate
    baseYears = Math.floor(baseTime / MS_PER_YEAR)
    currentYearStart = baseDate.getTime() + baseYears * MS_PER_YEAR
    return new Date(currentYearStart).getFullYear()

getGraduateYear = (cl) ->
    yearStart = getCurrentYearStart()
    yearStartDate = new Date(yearStart, 6, 1)
    graduateDate = yearStartDate.getTime() + (12 - cl) * MS_PER_YEAR
    return new Date(graduateDate).getFullYear()

userCache = {}

export default class InformaticsUser
    @getUser: (username, password) ->
        key = username + "::" + password
        if not userCache[key] or (new Date() - userCache[key].loginTime > 1000 * 60 * 60)
            logger.info "Creating new InformaticsUser ", username
            newUser = new InformaticsUser(username, password)
            await newUser.doLogin()
            userCache[key] =
                user: newUser
                loginTime: new Date()
        return userCache[key].user

    @findAdmin: () ->
        admin = await RegisteredUser.findAdmin()
        return @getUser(admin.informaticsUsername, admin.informaticsPassword)

    constructor: (@username, @password) ->
        @jar = request.jar()
        @requests = 0
        @promises = []

    doLogin: () ->
        page = await download("https://informatics.msk.ru/login/index.php", @jar, {
            method: 'POST',
            form: {
                username: @username,
                password: @password
            },
            followAllRedirects: true,
            timeout: 30 * 1000
        })
        document = (new JSDOM(page)).window.document
        el = document.getElementsByClassName("logininfo")
        if el.length == 0 or el[0].children.length == 0
            throw "Can't log user in"
        a = el[0].children[0]
        id = a.href.match(/view.php\?id=(\d+)/)
        @name = a.innerHTML
        if not id or id.length < 2
            throw "Can't detect id, href=" + a.href + " username=" + @username
        logger.info "Logged in user #{@username} href=#{a.href}"
        @id = id[1]
        return
            id: @id,
            name: @name

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

    getData: () ->
        page = await download("https://informatics.msk.ru/user/edit.php?id=#{@id}", @jar)
        document = (new JSDOM(page)).window.document
        fields = ["id_lastname",
                  "id_firstname",
                  "id_city",
                  "id_country",
                  "id_profile_field_School",
                  "id_profile_field_class",
                  "id_profile_field_graduateyear"]
        data = {}
        for field in fields
            data[field] = document.getElementById(field)?.value
        @name = data.id_firstname + " " + data.id_lastname
        @city = data.id_city
        @country = data.id_country
        @school = data.id_profile_field_School
        @class = data.id_profile_field_class
        @graduateYear = data.id_profile_field_graduateyear
        if @class?
            # 'values' for class select are inverted and start from 0 for 11 class
            @class = 11 - @class
            if @class <= 2
                @class = null
                @graduateYear = null
            else
                @graduateYear = getGraduateYear(@class)
                @class = getClassStartingFromJuly(@graduateYear)
        else if @graduateYear
            @graduateYear = @graduateYear + 2014
            @class = getClassStartingFromJuly(@graduateYear)
        else
            @class = null
            @graduateYear = null

        return
            id: @id
            name: @name
            class: @class
            school: @school
            city: @city
            graduateYear: @graduateYear
            country: @country
            currentYearStart: getCurrentYearStart()

    submit: (problemId, contentType, body) ->
        page = await download("https://informatics.msk.ru/py/problem/#{problemId}/submit", @jar, {
            method: 'POST',
            headers: {'Content-Type': contentType},
            body,
            followAllRedirects: true
        })
        res = JSON.parse(page)
        if res.res != "ok"
            throw "Can't submit"
