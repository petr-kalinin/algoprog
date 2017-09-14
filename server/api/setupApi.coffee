connectEnsureLogin = require('connect-ensure-login')

import User from '../models/user'
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

import InformaticsUser from '../informatics/api'

wrap = (fn) ->
    (args...) ->
        try
            await fn(args...)
        catch error
            args[2](error)

export default setupApi = (app) ->
    app.post '/api/register', wrap (req, res, next) ->
        logger.info("Try register user", req.body.username)
        user = new RegisteredUser
            username: req.body.username
            admin: false
        RegisteredUser.register user, req.body.password, (err) ->
            if (err)
                logger.error("Can register user", err)
                return next err
            logger.info("Regitered user")
            res.redirect '/'

    app.get('/api/me', connectEnsureLogin.ensureLoggedIn(), wrap (req, res) ->
        res.json req.user
    )

    app.post '/api/user/:id/set', connectEnsureLogin.ensureLoggedIn(), wrap (req, res) ->
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

    app.get '/api/material/:id', wrap (req, res) ->
        res.json(await Material.findById(req.params.id))

    app.get '/api/updateResults', connectEnsureLogin.ensureLoggedIn(), wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        await updateAllResults()
        res.send('OK')

    app.get '/api/downloadMaterials', connectEnsureLogin.ensureLoggedIn(), wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        downloadMaterials()
        res.send('OK')

    app.get '/api/downloadContests', connectEnsureLogin.ensureLoggedIn(), wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        downloadContests.run()
        res.send('OK')

    app.get '/api/downloadAllSubmits', connectEnsureLogin.ensureLoggedIn(), wrap (req, res) ->
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
