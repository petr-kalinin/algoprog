request = require('request-promise-native')

import {getGraduateYear} from '../../client/lib/graduateYearToClass'

import InformaticsUser from '../informatics/InformaticsUser'

import download from '../lib/download'
import sleep from '../lib/sleep'
import {OtpGetter, OtpFilterType} from '../lib/otpGetter'
import {notify, notifyDocument} from '../lib/telegramBot'

import User from '../models/user'
import RegisteredUser from '../models/registeredUser'

import { REGISTRY } from '../testSystems/TestSystemRegistry'

import logger from '../log'

randomString = (len) ->
    Math.random().toString(36).substr(2, len)

filterUsername = (username) ->
    return username.replace(/[^a-zA-Z]/gm, "").toLowerCase()

otpGetter = new OtpGetter()

findConfirmLink = (login, email) ->
    try
        return await otpGetter.getOtp(email, OtpFilterType.InformaticsActivate, [], 5 * 60 * 1000)
    catch e
        logger.error(e)
        return undefined
    return undefined

registerOnInformatics = (data) ->
    logger.info("Try register new user on informatics")
    jar = request.jar()
    page = await download("https://informatics.msk.ru/login/signup.php", jar)
    sesskey = /input name="sesskey" type="hidden" value="(\w+)"/.exec(page)?[1]
    logger.info "Found sesskey=#{sesskey}"
    username = "algoprog_" + filterUsername(data.username) + "_" + randomString(4)
    password = randomString() + "aA1-"
    email = "#{username}@algoprog.ru"
    name = data.informaticsName.trim().split(' ')
    school = data.informaticsSchool
    cls = +data.informaticsClass
    if isNaN(cls)
        cls = null
    city = data.informaticsCity
    logger.info("Generated username=#{username}, password=#{password} email=#{email} name=#{name} city=#{city} school=#{school} cls=#{cls}")
    page = await download("https://informatics.msk.ru/login/signup.php", jar, {
        method: 'POST',
        form: {
            sesskey,
            _qf__login_signup_form: 1
            mform_isexpanded_id_createuserandpass: 1
            mform_isexpanded_id_supplyinfo: 1
            mform_isexpanded_id_category_3: 1
            mform_isexpanded_id_category_1: 1
            mform_isexpanded_id_category_2: 0
            username,
            password,
            email,
            email2: email
            firstname: name[0]
            lastname: name[1] || ""
            city: city || "-"
            country: "RU"
            profile_field_usertype: "Школьник"
            profile_field_School: school || 123
            profile_field_class: cls || 11
            profile_field_graduateyear: 2014
            submitbutton: "Создать мой новый аккаунт"
        },
        followAllRedirects: true,
        timeout: 30 * 1000
    })
    link = await findConfirmLink(username, email)
    if not link
        logger.info("Generated username=#{username}, password=#{password} email=#{email} name=#{name} name=#{name} city=#{city} school=#{school} cls=#{cls}")
        notify "Can't find notification link for login #{username}\n" + "Generated username=#{username}, password=#{password} email=#{email} name=#{name} name=#{name} city=#{city} school=#{school} cls=#{cls}"
        notifyDocument page, {filename: 'page.html', contentType: "text/html"}
        throw "Can't find notification link for login #{username}"
    notify "Found notification link for login #{username}\n" + "Generated username=#{username}, password=#{password} email=#{email} name=#{name} name=#{name} city=#{city} school=#{school} cls=#{cls}"
    await download(link)
    return 
        username: username,
        password: password


export default register = (req, res, next) ->
    logger.info("Try register user", req.body.username)
    {username, password, informaticsUsername, informaticsPassword, aboutme, cfLogin, promo, contact, whereFrom, hasInformatics} = req.body
    hasInformatics = true
    if not informaticsUsername
        hasInformatics = false
        registrationResult = await registerOnInformatics(req.body)
        informaticsUsername = registrationResult.username
        informaticsPassword = registrationResult.password

    informaticsUser = await InformaticsUser.getUser(informaticsUsername, informaticsPassword)
    informaticsData = await informaticsUser.getData()

    oldUser = await User.findById(informaticsData.id)
    if not oldUser
        logger.info "Register new Table User", informaticsData.id
        newUser = new User(
            _id: informaticsData.id,
            name: (hasInformatics && informaticsData.name) || req.body.informaticsName,
            graduateYear: (hasInformatics && informaticsData.graduateYear) || (getGraduateYear(req.body.informaticsClass)),
            userList: "unknown",
            activated: false,
            lastActivated: new Date()
            registerDate: new Date()
            prefs:
                interfaceLanguage: req.body.interfaceLanguage
        )
        if cfLogin
            newUser.cf =
                login: cfLogin
        await newUser.upsert()
        if cfLogin
            await newUser.updateCfRating()
        await newUser.updateLevel()
        await newUser.updateRatingEtc()

        # do not await, this can happen asynchronously
        for _, system of REGISTRY
            system.registerUser(newUser)
    else
        logger.info "Table User already registered"

    newRegisteredUser = new RegisteredUser({
        username,
        informaticsId: informaticsData.id,
        informaticsUsername,
        informaticsPassword,
        aboutme,
        promo,
        contact,
        whereFrom
        admin: false
    })
    RegisteredUser.register newRegisteredUser, req.body.password, (err) ->
        if (err)
            logger.error("Cant register user", err)
            res.json
                registered:
                    error: true
                    message: if err.name == "UserExistsError" then "duplicate" else "unknown"
        else
            logger.info("Registered user")
            res.json({registered: {success: true}})

"""
(() ->
    await sleep(10000)
    console.log await findConfirmLink("algoprog_pkalinintest_t45w"))()
"""
