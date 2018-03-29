import User from '../models/user'
import RegisteredUser from '../models/registeredUser'
import InformaticsUser from '../informatics/InformaticsUser'

import logger from '../log'

UNKNOWN_GROUP = '7647'

addUserToUnknownGroup = (uid) ->
    adminUser = await InformaticsUser.findAdmin()

    href = "http://informatics.mccme.ru/moodle/ajax/ajax.php?sid=&objectName=group&objectId=#{UNKNOWN_GROUP}&selectedName=users&action=add"
    body = 'addParam={"id":"' + uid + '"}&group_id=&session_sid='
    await adminUser.download(href, {
        method: 'POST',
        headers: {'Content-Type': "application/x-www-form-urlencoded; charset=UTF-8"},
        body: body,
        followAllRedirects: true
    })

export default register = (req, res, next) ->
    logger.info("Try register user", req.body.username)
    {username, password, informaticsUsername, informaticsPassword, aboutme, cfLogin} = req.body

    informaticsUser = await InformaticsUser.getUser(informaticsUsername, informaticsPassword)
    informaticsData = await informaticsUser.getData()

    oldUser = await User.findById(informaticsData.id)
    if not oldUser
        logger.info "Register new Table User", informaticsData.id
        newUser = new User(
            _id: informaticsData.id,
            name: informaticsData.name,
            userList: "unknown",
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
        addUserToUnknownGroup(informaticsData.id)
    else
        logger.info "Table User already registered"

    newRegisteredUser = new RegisteredUser({
        username,
        informaticsId: informaticsData.id,
        informaticsUsername,
        informaticsPassword,
        aboutme,
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
