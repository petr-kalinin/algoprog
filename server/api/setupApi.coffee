connectEnsureLogin = require('connect-ensure-login')
passport = require('passport')

import User from '../models/user'
import Submit from '../models/submit'
import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'
import RegisteredUser from '../models/registeredUser'
import Material from '../models/Material'

import dashboard from './dashboard'
import table, * as tableApi from './table'

import logger from '../log'

import {updateAllResults} from '../calculations/updateResults'
import downloadMaterials from '../cron/downloadMaterials'
import * as downloadContests from '../cron/downloadContests'
import * as downloadSubmits from "../cron/downloadSubmits"

import InformaticsUser from '../informatics/InformaticsUser'

ensureLoggedIn = connectEnsureLogin.ensureLoggedIn("/api/forbidden")

wrap = (fn) ->
    (args...) ->
        try
            await fn(args...)
        catch error
            args[2](error)

export default setupApi = (app) ->
    app.get '/api/forbidden', wrap (req, res) ->
        res.status(403).send('No permissions')

    app.post '/api/register', wrap (req, res, next) ->
        logger.info("Try register user", req.body.username)
        {username, password, informaticsUsername, informaticsPassword, aboutme, cfLogin} = req.body

        informaticsUser = new InformaticsUser(informaticsUsername, informaticsPassword)
        informaticsData = await informaticsUser.getData()

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

    app.post '/api/login', passport.authenticate('local'), wrap (req, res) ->
        res.json({logged: true})

    app.get '/api/logout', wrap (req, res) ->
        req.logout()
        res.json({loggedOut: true})

    app.get '/api/me', ensureLoggedIn, wrap (req, res) ->
        res.json req.user

    app.get '/api/myUser', ensureLoggedIn, wrap (req, res) ->
        User.findOne({_id: req.user.informaticsId}, (err, record) ->
            res.json(record)
        )

    app.post '/api/user/:id/set', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        cfLogin = req.body.cf.login
        if cfLogin == ""
            cfLogin = undefined
        User.findOne({_id: req.params.id}, (err, record) ->
            await record.setBaseLevel req.body.level.base
            await record.setCfLogin cfLogin
            res.send('OK')
        )

    app.get '/api/user/:id', wrap (req, res) ->
        User.findOne({_id: req.params.id}, (err, record) ->
            res.json(record)
        )

    app.get '/api/dashboard', wrap (req, res) ->
        res.json(await dashboard())

    app.get '/api/table/:userList/:table', wrap (req, res) ->
        res.json(await table(req.params.userList, req.params.table))

    app.get '/api/fullUser/:id', wrap (req, res) ->
        res.json(await tableApi.fullUser(req.params.id))

    app.get '/api/users/:userList', wrap (req, res) ->
        res.json(await User.findByList(req.params.userList))

    app.get '/api/submits/:user/:problem', wrap (req, res) ->
        res.json(await Submit.findByUserAndProblem(req.params.user, req.params.problem))

    app.get '/api/material/:id', wrap (req, res) ->
        res.json(await Material.findById(req.params.id))

    app.get '/api/updateResults', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        await updateAllResults()
        res.send('OK')

    app.get '/api/downloadMaterials', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        downloadMaterials()
        res.send('OK')

    app.get '/api/downloadContests', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        downloadContests.run()
        res.send('OK')

    app.get '/api/downloadAllSubmits', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        downloadSubmits.runAll()
        res.send('OK')

    app.post '/api/informatics/userData', wrap (req, res) ->
        username = req.body.username
        password = req.body.password
        user = new InformaticsUser(username, password)
        result = await user.getData()
        res.json(result)
