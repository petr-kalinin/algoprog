import { JSDOM } from 'jsdom'
request = require('request-promise-native')

import download from '../lib/download'

# this will give some mistake due to leap years, but we will neglect it
MS_PER_YEAR = 1000 * 60 * 60 * 24 * 365.25

getClass = (year) ->
    graduateDate = new Date(year, 7, 31)  # 31 august
    now = new Date()
    time = graduateDate - now
    if time < 0
        return null
    else
        return 11 - Math.floor(time / MS_PER_YEAR)

getCurrentYearStart = () ->
    baseDate = new Date(1990, 7, 31)
    now = new Date()
    baseTime = now - baseDate
    baseYears = Math.floor(baseTime / MS_PER_YEAR)
    currentYearStart = baseDate.getTime() + baseYears * MS_PER_YEAR
    return new Date(currentYearStart).getFullYear()

getGraduateYear = (cl) ->
    yearStart = getCurrentYearStart()
    yearStartDate = new Date(yearStart, 7, 31)
    graduateDate = yearStartDate.getTime() + (12 - cl) * MS_PER_YEAR
    return new Date(graduateDate).getFullYear()

export default class InformaticsUser
    constructor: (@username, @password) ->
        @jar = request.jar()

    doLogin: () ->
        page = await download("http://informatics.mccme.ru/login/index.php", @jar, {
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
        @id = id[1]
        return
            id: @id,
            name: @name

    download: (href) ->
        download(href, @jar)

    getData: () ->
        await @doLogin()
        page = await download("http://informatics.mccme.ru/user/edit.php?id=#{@id}", @jar)
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
        # 'values' for class select are inverted and start from 0 for 11 class
        @class = 11 - data.id_profile_field_class
        if @class <= 2
            @class = null
        if @class
            @graduateYear = getGraduateYear(@class)
            @class = getClass(@graduateYear)
        else
            @graduateYear = data.id_profile_field_graduateyear

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
        await @doLogin()
        page = await download("http://informatics.mccme.ru/py/problem/#{problemId}/submit", @jar, {
            method: 'POST',
            headers: {'Content-Type': contentType},
            body,
            followAllRedirects: true
        })
        res = JSON.parse(page)
        if res.res != "ok"
            throw "Can't submit"
