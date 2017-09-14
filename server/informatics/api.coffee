import { JSDOM } from 'jsdom'
request = require('request-promise-native')

import download from '../lib/download'

getClass = (year) ->
    console.log "year=", year
    graduateDate = new Date(year, 7, 31)  # 31 august
    now = new Date()
    time = graduateDate - now
    if time < 0
        return 12
    else
        # this will give some mistake due to leap years, but we will neglect it
        return 11 - Math.floor(time / 1000 / 60 / 60 / 24/ 365)

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
            followAllRedirects: true
        })
        document = (new JSDOM(page)).window.document
        el = document.getElementsByClassName("logininfo")
        if el.length == 0 or el[0].children.length == 0
            throw "Can't log user in"
        a = el[0].children[0]
        id = a.href.match(/view.php\?id=(\d+)/)
        @name = a.innerHTML
        if not id or id.length < 2
            throw "Can't detect id, href=" + a.href
        @id = id[1]
        return
            id: @id,
            name: @name

    getData: () ->
        await @doLogin()
        page = await download("http://informatics.mccme.ru/user/edit.php?id=#{@id}", @jar)
        document = (new JSDOM(page)).window.document
        fields = ["id_lastname",
                  "id_firstname",
                  "id_city",
                  "id_country",
                  "id_profile_field_School",
                  "id_profile_field_graduateyear"]
        data = {}
        for field in fields
            data[field] = document.getElementById(field)?.value
        @name = data.id_firstname + " " + data.id_lastname
        @city = data.id_city
        @country = data.id_country
        @school = data.id_profile_field_School
        @graduateYear = +data.id_profile_field_graduateyear + 2008
        @class = getClass(@graduateYear)

        return
            name: @name
            class: @class
            school: @school
            city: @city
            country: @country
