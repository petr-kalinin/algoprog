connectEnsureLogin = require('connect-ensure-login')
passport = require('passport')

import User from '../models/user'
import Submit from '../models/submit'
import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'
import SubmitComment from '../models/SubmitComment'
import RegisteredUser from '../models/registeredUser'
import Material from '../models/Material'

import dashboard from './dashboard'
import table, * as tableApi from './table'
import register from './register'

import logger from '../log'

import updateResults, {updateAllResults} from '../calculations/updateResults'
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

    app.post '/api/register', wrap register
    app.post '/api/login', passport.authenticate('local'), wrap (req, res) ->
        res.json({logged: true})

    app.get '/api/logout', wrap (req, res) ->
        req.logout()
        res.json({loggedOut: true})

    app.post '/api/submit/:problemId', ensureLoggedIn, wrap (req, res) ->
        try
            informaticsUser = new InformaticsUser(req.user.informaticsUsername, req.user.informaticsPassword)
            informaticsData = await informaticsUser.submit(req.params.problemId, req.get('Content-Type'), req.body)
        finally
            await downloadSubmits.runForUser(req.user.informaticsId, 5, 1)
        res.json({submit: true})

    app.get '/api/me', ensureLoggedIn, wrap (req, res) ->
        user = JSON.parse(JSON.stringify(req.user))
        delete user.informaticsPassword
        res.json user

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

    app.get '/api/registeredUsers', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        res.json(await RegisteredUser.find({}))

    app.get '/api/submits/:user/:problem', wrap (req, res) ->
        res.json(await Submit.findByUserAndProblem(req.params.user, req.params.problem))

    app.get '/api/material/:id', wrap (req, res) ->
        res.json(await Material.findById(req.params.id))

    app.get '/api/submit/:id', wrap (req, res) ->
        res.json(await Submit.findById(req.params.id))

    app.get '/api/lastComments/:user', wrap (req, res) ->
        res.json(await SubmitComment.findLastByUser(req.params.user))

    app.get '/api/updateResults/:user', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        await User.updateUser(req.params.user)
        res.send('OK')

    app.get '/api/updateAllResults', ensureLoggedIn, wrap (req, res) ->
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

    app.get '/api/downloadSubmits/:user', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        await downloadSubmits.runForUser(req.params.user, 100, 1e9)
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
