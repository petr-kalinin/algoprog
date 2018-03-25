connectEnsureLogin = require('connect-ensure-login')
passport = require('passport')
iconv = require('iconv-lite')
Entities = require('html-entities').XmlEntities

import User from '../models/user'
import Submit from '../models/submit'
import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'
import SubmitComment from '../models/SubmitComment'
import RegisteredUser from '../models/registeredUser'
import Material from '../models/Material'
import BlogPost from '../models/BlogPost'

import dashboard from './dashboard'
import table, * as tableApi from './table'
import register from './register'
import setOutcome from './setOutcome'

import logger from '../log'

import downloadMaterials from '../cron/downloadMaterials'
import * as downloadContests from '../cron/downloadContests'
import * as downloadSubmits from "../cron/downloadSubmits"
import * as groups from '../informatics/informaticsGroups'

import InformaticsUser from '../informatics/InformaticsUser'

ensureLoggedIn = connectEnsureLogin.ensureLoggedIn("/api/forbidden")
entities = new Entities()

wrap = (fn) ->
    (args...) ->
        try
            _debug_marker = {qwe: '53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53_53'}
            await fn(args...)
        catch error
            args[2](error)

expandSubmit = (submit) ->
    _debug_marker = {qwe: '54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54_54'}
    submit.fullUser = await User.findById(submit.user)
    _debug_marker = {qwe: '55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55'}
    submit.fullProblem = await Problem.findById(submit.problem)
    tableNamePromises = []
    for t in submit.fullProblem.tables
        tableNamePromises.push(Table.findById(t))
    _debug_marker = {qwe: '56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56_56'}
    tableNames = (await Promise.all(tableNamePromises)).map((table) -> table.name)
    submit.fullProblem.tables = tableNames
    return submit

createDraftSubmit = (problemId, userId, language, code) ->
    code = iconv.decode(new Buffer(code), "latin1")
    code = entities.encode(code)
    time = new Date
    timeStr = +time
    submit = new Submit
        _id: "#{userId}r#{timeStr}#{problemId}" ,
        time: time,
        user: userId,
        problem: problemId,
        outcome: "DR"
        source: code
        language: language
        comments: []
        results: []
        force: false
    _debug_marker = {qwe: '57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57_57'}
    await submit.upsert()

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
        fullProblemId = "p" + req.params.problemId
        try
            _debug_marker = {qwe: '58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58_58'}
            oldSubmits = await Submit.findByUserAndProblem(req.user.informaticsId, fullProblemId)
            try
                _debug_marker = {qwe: '59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59_59'}
                informaticsUser = await InformaticsUser.getUser(req.user.informaticsUsername, req.user.informaticsPassword)
                _debug_marker = {qwe: '60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60_60'}
                informaticsData = await informaticsUser.submit(req.params.problemId, req.get('Content-Type'), req.body)
            finally
                _debug_marker = {qwe: '61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61_61'}
                await downloadSubmits.runForUser(req.user.informaticsId, 5, 1)
        catch e
            _debug_marker = {qwe: '62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62_62'}
            newSubmits = await Submit.findByUserAndProblem(req.user.informaticsId, fullProblemId)
            if oldSubmits.length == newSubmits.length
                throw e
        res.json({submit: true})

    app.post '/api/submit/:problemId/draft', ensureLoggedIn, wrap (req, res) ->
        _debug_marker = {qwe: '63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63_63'}
        await createDraftSubmit("p" + req.params.problemId, req.user.informaticsId, req.body.language, req.body.code)
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
            return
        cfLogin = req.body.cf.login
        if cfLogin == ""
            cfLogin = undefined
        User.findOne({_id: req.params.id}, (err, record) ->
            _debug_marker = {qwe: '64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64_64'}
            await record.setBaseLevel req.body.level.base
            _debug_marker = {qwe: '65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65_65'}
            await record.setCfLogin cfLogin
            res.send('OK')
        )

    app.get '/api/user/:id', wrap (req, res) ->
        User.findOne({_id: req.params.id}, (err, record) ->
            res.json(record)
        )

    app.get '/api/dashboard', wrap (req, res) ->
        _debug_marker = {qwe: '66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66_66'}
        res.json(await dashboard())

    app.get '/api/table/:userList/:table', wrap (req, res) ->
        _debug_marker = {qwe: '67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67_67'}
        res.json(await table(req.params.userList, req.params.table))

    app.get '/api/fullUser/:id', wrap (req, res) ->
        _debug_marker = {qwe: '68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68_68'}
        res.json(await tableApi.fullUser(req.params.id))

    app.get '/api/users/:userList', wrap (req, res) ->
        _debug_marker = {qwe: '69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69_69'}
        res.json(await User.findByList(req.params.userList))

    app.get '/api/registeredUsers', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        _debug_marker = {qwe: '70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70_70'}
        res.json(await RegisteredUser.find({}))

    app.get '/api/submits/:user/:problem', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin and ""+req.user?.informaticsId != ""+req.params.user
            res.status(403).send('No permissions')
            return
        _debug_marker = {qwe: '71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71_71'}
        submits = await Submit.findByUserAndProblem(req.params.user, req.params.problem)
        submits = submits.map((submit) -> submit.toObject())
        submits = submits.map(expandSubmit)
        _debug_marker = {qwe: '72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72_72'}
        submits = await Promise.all(submits)
        res.json(submits)

    app.get '/api/material/:id', wrap (req, res) ->
        _debug_marker = {qwe: '73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73_73'}
        res.json(await Material.findById(req.params.id))

    app.get '/api/lastBlogPosts', wrap (req, res) ->
        _debug_marker = {qwe: '74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74_74'}
        res.json(await BlogPost.findLast(5, 1000 * 60 * 60 * 24 * 60))

    app.get '/api/result/:id', wrap (req, res) ->
        _debug_marker = {qwe: '75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75_75'}
        result = (await Result.findById(req.params.id)).toObject()
        _debug_marker = {qwe: '76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76_76'}
        result.fullUser = await User.findById(result.user)
        _debug_marker = {qwe: '77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77_77'}
        result.fullTable = await Problem.findById(result.table)
        res.json(result)

    app.get '/api/userResults/:userId', wrap (req, res) ->
        _debug_marker = {qwe: '78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78_78'}
        results = (await Result.findByUser(req.params.userId))
        json = {}
        for r in results
            r = r.toObject()
            json[r._id] = r
        res.json(json)

    app.get '/api/submit/:id', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin and ""+req.user?.informaticsId != ""+req.params.user
            res.status(403).send('No permissions')
            return
        _debug_marker = {qwe: '79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79_79'}
        submit = (await Submit.findById(req.params.id)).toObject()
        submit = expandSubmit(submit)
        res.json(submit)

    app.get '/api/lastComments', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.informaticsId
            res.status(403).send('No permissions')
            return
        _debug_marker = {qwe: '80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80_80'}
        res.json(await SubmitComment.findLastNotViewedByUser(req.user?.informaticsId))

    app.get '/api/lastCommentsByProblem/:problem', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        _debug_marker = {qwe: '81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81_81'}
        res.json(await SubmitComment.findLastByProblem(req.params.problem))

    app.get '/api/bestSubmits/:problem', ensureLoggedIn, wrap (req, res) ->
        allowed = false
        if req.user?.admin
            allowed = true
        else if req.user?.informaticsId
            _debug_marker = {qwe: '82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82_82'}
            result = await Result.findByUserAndTable(req.user?.informaticsId, req.params.problem)
            allowed = result && result.solved > 0
        if not allowed
            res.status(403).send('No permissions')
            return
        _debug_marker = {qwe: '83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83_83'}
        res.json(await Submit.findBestByProblem(req.params.problem, 5))

    app.post '/api/setOutcome/:submitId', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        setOutcome(req, res)

    app.post '/api/setQuality/:submitId/:quality', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        _debug_marker = {qwe: '84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84_84'}
        submit = await Submit.findById(req.params.submitId)
        if not submit
            res.status(404).send('Submit not found')
            return
        submit.quality = req.params.quality
        _debug_marker = {qwe: '85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85_85'}
        await submit.save()
        res.send('OK')

    app.post '/api/setCommentViewed/:commentId', ensureLoggedIn, wrap (req, res) ->
        _debug_marker = {qwe: '86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86_86'}
        comment = await SubmitComment.findById(req.params.commentId)
        console.log "Set comment viewed ", req.params.commentId, ""+req.user?.informaticsId, "" + comment?.userId
        if ""+req.user?.informaticsId != "" + comment?.userId
            res.status(403).send('No permissions')
            return
        comment.viewed = true
        _debug_marker = {qwe: '87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87_87'}
        await comment.save()
        res.send('OK')

    app.post '/api/moveUserToGroup/:userId/:groupName', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        _debug_marker = {qwe: '88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88_88'}
        user = await User.findById(req.params.userId)
        if not user
            res.status(400).send("User not found")
            return
        _debug_marker = {qwe: '89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89_89'}
        adminUser = await InformaticsUser.findAdmin()
        _debug_marker = {qwe: '90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90_90'}
        await groups.moveUserToGroup(adminUser, req.params.userId, req.params.groupName)
        if req.params.groupName != "none"
            _debug_marker = {qwe: '91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91_91'}
            await user.setUserList(req.params.groupName)
        res.send('OK')

    app.get '/api/updateResults/:user', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        _debug_marker = {qwe: '92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92_92'}
        await User.updateUser(req.params.user)
        res.send('OK')

    app.get '/api/updateAllResults', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        User.updateAllUsers()
        res.send('OK')

    app.get '/api/updateAllCf', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        User.updateAllCf()
        res.send('OK')

    app.get '/api/downloadMaterials', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        downloadMaterials()
        res.send('OK')

    app.get '/api/downloadContests', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        downloadContests.run()
        res.send('OK')

    app.get '/api/downloadSubmits/:user', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        _debug_marker = {qwe: '93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93_93'}
        await downloadSubmits.runForUser(req.params.user, 100, 1e9)
        res.send('OK')

    app.get '/api/downloadAllSubmits', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        downloadSubmits.runAll()
        res.send('OK')

    app.post '/api/informatics/userData', wrap (req, res) ->
        username = req.body.username
        password = req.body.password
        _debug_marker = {qwe: '94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94_94'}
        user = await InformaticsUser.getUser(username, password)
        _debug_marker = {qwe: '95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95_95'}
        result = await user.getData()
        res.json(result)
