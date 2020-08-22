import User from '../models/user'
import RegisteredUser from '../models/registeredUser'
import InformaticsUser from '../informatics/InformaticsUser'

import { REGISTRY } from '../testSystems/TestSystemRegistry'

import logger from '../log'

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
