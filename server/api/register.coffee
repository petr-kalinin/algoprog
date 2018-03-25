import User from '../models/user'
import RegisteredUser from '../models/registeredUser'
import InformaticsUser from '../informatics/InformaticsUser'

import logger from '../log'

UNKNOWN_GROUP = '7647'

addUserToUnknownGroup = (uid) ->
    _debug_marker = {qwe: '28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28_28'}
    adminUser = await InformaticsUser.findAdmin()

    href = "http://informatics.mccme.ru/moodle/ajax/ajax.php?sid=&objectName=group&objectId=#{UNKNOWN_GROUP}&selectedName=users&action=add"
    body = 'addParam={"id":"' + uid + '"}&group_id=&session_sid='
    _debug_marker = {qwe: '29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29_29'}
    await adminUser.download(href, {
        method: 'POST',
        headers: {'Content-Type': "application/x-www-form-urlencoded; charset=UTF-8"},
        body: body,
        followAllRedirects: true
    })

export default register = (req, res, next) ->
    logger.info("Try register user", req.body.username)
    {username, password, informaticsUsername, informaticsPassword, aboutme, cfLogin} = req.body

    _debug_marker = {qwe: '30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30_30'}
    informaticsUser = await InformaticsUser.getUser(informaticsUsername, informaticsPassword)
    _debug_marker = {qwe: '31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31_31'}
    informaticsData = await informaticsUser.getData()

    _debug_marker = {qwe: '32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32_32'}
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
        _debug_marker = {qwe: '33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33'}
        await newUser.upsert()
        if cfLogin
            _debug_marker = {qwe: '34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34_34'}
            await newUser.updateCfRating()
        _debug_marker = {qwe: '35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35_35'}
        await newUser.updateLevel()
        _debug_marker = {qwe: '36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36_36'}
        await newUser.updateRatingEtc()

        _debug_marker = {qwe: '37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37_37'}
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
