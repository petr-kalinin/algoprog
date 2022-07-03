{ImapFlow} = require('imapflow')
mailparser = require('mailparser')

import User from '../models/user'
import RegisteredUser from '../models/registeredUser'
import InformaticsUser from '../informatics/InformaticsUser'

import { REGISTRY } from '../testSystems/TestSystemRegistry'

import logger from '../log'

imapClient = new ImapFlow
    host: 'imap.gmail.com',
    port: 993,
    secure: true,
    auth:
        user: process.env["EMAIL_USER"],
        pass: process.env["EMAIL_PASSWORD"]


registerOnInformatics = () ->
    ###
    logger.info("Try register new user on informatics")
    @jar = request.jar()
    page = await download("https://informatics.msk.ru/login/signup.php", jar, {
        method: 'POST',
        form: {
            # sesskey: QLYaui8PHd
            _qf__login_signup_form: 1
            mform_isexpanded_id_createuserandpass: 1
            mform_isexpanded_id_supplyinfo: 1
            mform_isexpanded_id_category_3: 1
            mform_isexpanded_id_category_1: 1
            mform_isexpanded_id_category_2: 0
            username: pkalinintest_20220703
            password: Pi9.8696
            email: petr+test@kalinin.nnov.ru
            email2: petr+test@kalinin.nnov.ru
            firstname: Петр
            lastname: Калинин
            city: 
            country: RU
            profile_field_usertype: Школьник
            profile_field_School: 23
            profile_field_class: 9
            profile_field_graduateyear: 2014
            submitbutton: Создать мой новый аккаунт
        },
        followAllRedirects: true,
        timeout: 30 * 1000
    })
    ###


getEmails = () ->
    await imapClient.connect()
    lock = await imapClient.getMailboxLock('INBOX')
    try
        console.log "Will fetch"
        rawMessages = await imapClient.fetch('1:10', { source: true })
        console.log "Fetched!!"
        messages = []
        `for await (let message of rawMessages) {
            messages.push(message.source.toString('utf8'));
        }`
        for msg in messages
            console.log (await mailparser.simpleParser(msg)).text
        return 1
    finally
        await lock.release();

export default register = (req, res, next) ->
    logger.info("Try register user", req.body.username)
    {username, password, informaticsUsername, informaticsPassword, aboutme, cfLogin, promo, contact, whereFrom} = req.body

    informaticsUser = await InformaticsUser.getUser(informaticsUsername, informaticsPassword)
    informaticsData = await informaticsUser.getData()

    oldUser = await User.findById(informaticsData.id)
    if not oldUser
        logger.info "Register new Table User", informaticsData.id
        newUser = new User(
            _id: informaticsData.id,
            name: informaticsData.name,
            graduateYear: informaticsData.graduateYear,
            userList: "unknown",
            activated: false,
            lastActivated: new Date()
            registerDate: new Date()
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
                    message: if err.name == "UserExistsError" then "Пользователь с таким логином уже сущестует" else "Неопознанная ошибка"
        else
            logger.info("Registered user")
            res.json({registered: {success: true}})

getEmails()
