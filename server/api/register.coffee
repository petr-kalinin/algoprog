import User from '../models/user'
import RegisteredUser from '../models/registeredUser'
import InformaticsUser from '../informatics/InformaticsUser'

import { REGISTRY } from '../testSystems/TestSystemRegistry'

import logger from '../log'


registerInSystems = (user, registeredUser, password) ->
    for _, system of REGISTRY
        await system.registerUser(user, registeredUser, password)
    await user.upsert()
    await registeredUser.upsert()



export default register = (req, res, next) ->
    logger.info("Try register user", req.body.username)
    {username, password, name} = req.body

    oldUser = await User.findById(username)
    if not oldUser
        logger.info "Register new Table User", username
        newUser = new User(
            _id: username,
            name: name,
            userList: "all",
            lastActivated: new Date()
            registerDate: new Date()
        )
        await newUser.upsert()
        await newUser.updateLevel()
        await newUser.updateRatingEtc()

    else
        logger.info "Table User already registered"

    newRegisteredUser = new RegisteredUser({
        username: username,
        ejudgeUsername: username,
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
            registerInSystems(newUser, newRegisteredUser, req.body.password)
            logger.info("Registered user")
            res.json({registered: {success: true}})
