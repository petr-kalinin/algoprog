seedrandom = require('seedrandom')
React = require('react')
connectEnsureLogin = require('connect-ensure-login')
passport = require('passport')
iconv = require('iconv-lite')
Entities = require('html-entities').XmlEntities
sha256 = require('sha256')
FileType = require('file-type')
deepcopy = require('deepcopy')
moment = require('moment')
XRegExp = require('xregexp')

import { renderToString } from 'react-dom/server';
import { StaticRouter } from 'react-router'

import {UserNameRaw} from '../../client/components/UserName'
import awaitAll from '../../client/lib/awaitAll'

import * as downloadSubmits from "../cron/downloadSubmits"
import InformaticsUser from '../informatics/InformaticsUser'

import download, {getStats} from '../lib/download'
import normalizeCode from '../lib/normalizeCode'
import sleep from '../lib/sleep'

import notify from '../metrics/notify'

import Material from '../models/Material'
import Problem from '../models/problem'
import RegisteredUser from '../models/registeredUser'
import Result from '../models/result'
import Submit from '../models/submit'
import SubmitComment from '../models/SubmitComment'
import User from '../models/user'

import {addMongooseCallback} from '../mongo/MongooseCallbackManager'

import getTestSystem from '../testSystems/TestSystemRegistry'
import {LoggedCodeforcesUser} from '../testSystems/Codeforces'

import logger from '../log'

import dashboard from './dashboard'
import register from './register'
import setOutcome from './setOutcome'


ensureLoggedIn = connectEnsureLogin.ensureLoggedIn("/api/forbidden")
entities = new Entities()

PASSWORD = process.env["TINKOFF_PASSWORD"]

wrap = (fn) ->
    (args...) ->
        try
            await fn(args...)
        catch error
            args[2](error)

expandSubmit = (submit) ->
    submit = submit.toObject?() || submit
    MAX_SUBMIT_LENGTH = 100000

    containsBinary = (source) ->
        for ch in source
            if ch.charCodeAt(0) < 9
                return true
        return false

    submit.fullUser = await User.findById(submit.user)
    submit.fullProblem = await Problem.findById(submit.problem)
    tableNamePromises = []
    for t in submit.fullProblem.tables
        tableNamePromises.push(Table.findById(t))
    tableNames = (await awaitAll(tableNamePromises)).map((table) -> table.name)
    submit.fullProblem.tables = tableNames
    if (submit.source.length > MAX_SUBMIT_LENGTH or containsBinary(submit.source))
        submit.source = "Файл слишком длинный или бинарный"
    return submit

hideTests = (submit) ->
    hideOneTest = (test) ->
        res = {}
        for field in ["string_status", "status", "max_memory_used", "time", "real_time"]
            res[field] = test[field]
        return res

    if submit.results?.tests
        for key, test of submit.results.tests
            submit.results.tests[key] = hideOneTest(test)
    return submit

createSubmit = (problemId, userId, userList, language, codeRaw, draft, findMistake) ->
    logger.info("Creating submit #{userId} #{problemId}")
    codeRaw = iconv.decode(new Buffer(codeRaw), "latin1")
    codeRaw = normalizeCode(codeRaw)
    code = entities.encode(codeRaw)
    if not draft
        allSubmits = await Submit.findByUserAndProblemWithFindMistakeAny(userId, problemId)
        for s in allSubmits
            if s.outcome != "DR" and s.source == code
                throw "duplicate"
    problem = await Problem.findById(problemId)
    if not problem
        throw "Unknown problem #{problemId}"
    time = new Date
    timeStr = +time
    submit = new Submit
        _id: "#{userId}r#{timeStr}#{problemId}" ,
        time: time,
        user: userId,
        userList: userList,
        problem: problemId,
        outcome: if draft then "DR" else "PS"
        source: code
        sourceRaw: codeRaw
        language: language
        comments: []
        results: []
        force: false
        testSystemData: problem.testSystemData
        findMistake: findMistake
    await submit.calculateHashes()
    await submit.upsert()

    update = () ->
        dirtyResults = {}
        await setDirty(submit, dirtyResults, {})
        await User.updateUser(submit.user, dirtyResults)
    update()  # do this async
    return undefined

expandFindMistake = (mistake, admin, userKey) ->
    allowed = false
    if admin 
        allowed = true
    else if userKey
        result = await Result.findByUserAndTable(userKey, mistake.problem)
        allowed = result && result.solved > 0
    mistake = mistake.toObject()
    mistake.allowed = allowed
    if not allowed
        mistake.allowed = false
        mistake.source = ""
    mistake.fullProblem = await Problem.findById(mistake.problem)
    mistake.hash = sha256(mistake._id).substring(0, 4)
    return mistake

export default setupApi = (app) ->
    app.get '/api/ping', wrap (req, res) ->
        res.send('OK')

    app.get '/api/forbidden', wrap (req, res) ->
        res.status(403).send('No permissions')

    app.post '/api/register', wrap register
    
    app.post '/api/login', passport.authenticate('local'), wrap (req, res) ->
        res.json({logged: true})

    app.get '/api/logout', wrap (req, res) ->
        req.logout()
        res.json({loggedOut: true})

    app.post '/api/submit/:problemId', ensureLoggedIn, wrap (req, res) ->
        userPrivate = (await UserPrivate.findById(req.user.userKey()))?.toObject() || {}
        user = await User.findById(req.user.userKey())
        userObj = user?.toObject() || {}
        if unpaidBlocked({userObj..., userPrivate...})
            res.json({unpaid: true})
            return
        if user.dormant
            res.json({dormant: true})
            return
        try
            await createSubmit(req.params.problemId, req.user.userKey(), user.userList, req.body.language, req.body.code, req.body.draft, req.body.findMistake)
        catch e
            res.json({error: e})
            return
        if req.body.editorOn?
            user.setEditorOn(req.body.editorOn)
        res.json({submit: true})

    app.get '/api/me', ensureLoggedIn, wrap (req, res) ->
        user = JSON.parse(JSON.stringify(req.user))
        res.json user

    app.get '/api/myUser', ensureLoggedIn, wrap (req, res) ->
        id = req.user.informaticsId
        user = (await User.findById(id))?.toObject() || {}
        userPrivate = (await UserPrivate.findById(id))?.toObject() || {}
        res.json({user..., userPrivate...})

    app.get '/api/registeredUser/:id', wrap (req, res) ->
        registeredUser = await RegisteredUser.findByKey(req.params.id)
        result = {
            codeforcesUsername: registeredUser?.codeforcesUsername
        }
        res.json(result)

    app.post '/api/user/:id/set', ensureLoggedIn, wrap (req, res) ->
        # can't allow admins as we use req.user.* below
        if ""+req.user?.userKey() != ""+req.params.id
            res.status(403).send('No permissions')
            return
        password = req.body.password
        newPassword = req.body.newPassword
        try
            if newPassword != ""
                logger.info "Set user password", req.user.userKey()
                await req.user.changePassword(password, newPassword)
                await req.user.save()
            else
                if !(await req.user.authenticate(password)).user
                    throw err
        catch e
            res.json({passError:true})
            return
        registeredUsers = await RegisteredUser.findAllByKey(req.params.id)
        newInformaticsPassword = req.body.informaticsPassword
        informaticsUsername = req.user.informaticsUsername
        if newInformaticsPassword != ""
            try
                userq = await InformaticsUser.getUser(informaticsUsername, newInformaticsPassword)
                result = await userq.getData()
                if not ("name" of result)
                    throw "Can't find name"
                for registeredUser in registeredUsers
                        await registeredUser.updateInformaticPassword(newInformaticsPassword)
            catch
                # TODO: return error to user
        cfLogin = req.body.cf.login
        if cfLogin == ""
            cfLogin = undefined
        newName = req.body.newName
        user = await User.findById(req.params.id)
        await user.setCfLogin cfLogin
        if(req.body.clas !='' and req.body.clas!=null)
            await user.setGraduateYear getYear(+req.body.clas)
        else
            await user.setGraduateYear(undefined)
        await user.updateName newName
        if req.body.codeforcesPassword
            cfUser = await LoggedCodeforcesUser.getUser(req.body.codeforcesUsername, req.body.codeforcesPassword)
            for registeredUser in registeredUsers
                    await registeredUser.setCodeforces(cfUser.handle, req.body.codeforcesPassword)
        if not req.body.codeforcesUsername
            req.user.setCodeforces(undefined, undefined)
        await User.updateUser(user._id, {})
        res.send('OK')

    app.post '/api/user/:id/setAdmin', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        cfLogin = req.body.cf.login
        if cfLogin == ""
            cfLogin = undefined
        paidTill = new Date(req.body.paidTill)
        if isNaN(paidTill)
            paidTill = undefined
        price = req.body.price
        if price == ""
            price = undefined
        else
            price = +price
        password = req.body.password
        achieves = if req.body.achieves.length then req.body.achieves.split(" ") else []
        user = await User.findById(req.params.id)
        registeredUsers = await RegisteredUser.findAllByKey(req.params.id)
        await user.setGraduateYear req.body.graduateYear
        await user.setBaseLevel req.body.level.base
        await user.setCfLogin cfLogin
        await user.setAchieves achieves
        userPrivate = await UserPrivate.findById(req.params.id)
        if not userPrivate
            userPrivate = new UserPrivate({_id: req.params.id})
            await userPrivate.upsert()
            userPrivate = await UserPrivate.findById(req.params.id)
        await userPrivate.setPaidTill paidTill
        await userPrivate.setPrice price
        if password != ""
            for registeredUser in registeredUsers
                logger.info "Set user password", registeredUser.userKey()
                await registeredUser.setPassword(password)
                await registeredUser.save()
        await User.updateUser(user._id, {})
        res.send('OK')

    app.get '/api/user/:id', wrap (req, res) ->
        id = req.params.id
        user = (await User.findById(id))?.toObject() || {}
        userPrivate = {}
        if req.user?.admin or ""+req.user?.userKey() == ""+req.params.id
            userPrivate = (await UserPrivate.findById(id))?.toObject() || {}
        res.json({user..., userPrivate...})

    app.get '/api/dashboard', wrap (req, res) ->
        res.json(await dashboard(req.user))

    app.get '/api/users/:userList', wrap (req, res) ->
        res.json(await User.findByList(req.params.userList))

    app.post '/api/searchUser', ensureLoggedIn, wrap (req, res) ->
        addUserName = (user) ->
            fullUser = await User.findById(user.informaticsId)
            user.fullName = fullUser?.name
            user.registerDate = fullUser?.registerDate
            user.userList = fullUser?.userList
            user.dormant = fullUser?.dormant
            user.activated = fullUser?.activated

        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        promises = []
        result = []
        users = []
        for user in await User.search(req.body.searchString)
            user = user.toObject()
            users = users.concat(await RegisteredUser.findAllByKey(user._id))
        registeredUsers = await RegisteredUser.search(req.body.searchString)
        users = users.concat(registeredUsers)
        for user in users
            user = user.toObject()
            promises.push(addUserName(user))
            result.push(user)
        await awaitAll(promises)
        result.sort((a, b) -> (a.registerDate || new Date(0)) - (b.registerDate || new Date(0)))
        res.json(result)

    app.get '/api/registeredUsers', ensureLoggedIn, wrap (req, res) ->
        addUserName = (user) ->
            fullUser = await User.findById(user.informaticsId)
            user.fullName = fullUser?.name
            user.dormant = fullUser?.dormant
            user.registerDate = fullUser?.registerDate
            user.userList = fullUser?.userList
            user.dormant = fullUser?.dormant
            user.activated = fullUser?.activated

        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        result = []
        promises = []
        for user in await RegisteredUser.find({})
            user = user.toObject()
            delete user.informaticsPassword
            promises.push(addUserName(user))
            result.push(user)
        await awaitAll(promises)
        result = result.filter((user) -> (not user.dormant) and (user.registerDate > new Date() - 1000 * 60 * 60 * 24 * 100))
        result.sort((a, b) -> (a.registerDate || new Date(0)) - (b.registerDate || new Date(0)))
        res.json(result)

    app.get '/api/submits/:user/:problem', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin and ""+req.user?.userKey() != ""+req.params.user
            res.status(403).send('No permissions')
            return
        submits = await Submit.findByUserAndProblem(req.params.user, req.params.problem)
        submits = submits.map((submit) -> submit.toObject())
        if not req.user?.admin
            submits = submits.map(hideTests)
        submits = submits.map(expandSubmit)
        submits = await awaitAll(submits)
        res.json(submits)

    app.ws '/wsapi/submits/:user/:problem', (ws, req, next) ->
        addMongooseCallback ws, 'update_submit', req.user?.userKey(), ->
            if not req.user?.admin and ""+req.user?.userKey() != ""+req.params.user
                return
            submits = await Submit.findByUserAndProblem(req.params.user, req.params.problem)
            submits = submits.map((submit) -> submit.toObject())
            if not req.user?.admin
                submits = submits.map(hideTests)
            submits = submits.map(expandSubmit)
            submits = await awaitAll(submits)
            ws.send JSON.stringify submits

    app.get '/api/material/:id', wrap (req, res) ->
        res.json(await Material.findById(req.params.id))

    app.get '/api/result/:id', wrap (req, res) ->
        result = (await Result.findById(req.params.id))?.toObject()
        if not result
            res.json({})
            return
        result.fullUser = await User.findById(result.user)
        result.fullTable = await Problem.findById(result.table)
        res.json(result)

    app.ws '/wsapi/result/:id', (ws, req, next) ->
        addMongooseCallback ws, 'update_result', req.user?.userKey(), ->
            result = (await Result.findById(req.params.id))?.toObject()
            if not result then return
            result.fullUser = await User.findById(result.user)
            result.fullTable = await Problem.findById(result.table)
            ws.send JSON.stringify result

    app.get '/api/userResults/:userId', wrap (req, res) ->
        results = (await Result.findByUser(req.params.userId))
        json = {}
        for r in results
            r = r.toObject()
            json[r._id] = r
        res.json(json)

    app.get '/api/submitSource/:id', ensureLoggedIn, wrap (req, res) ->
        submit = await Submit.findById(req.params.id)
        if not req.user?.admin and ""+req.user?.userKey() != ""+submit.user
            if submit.quality == 0
                res.status(403).send('No permissions')
                return
            result = await Result.findByUserAndTable(req.user?.userKey(), submit.problem)
            if not result or result.solved <= 0
                res.status(403).send('No permissions')
                return
        source = submit.sourceRaw || entities.decode(submit.source)
        mimeType = FileType.fromBuffer(Buffer.from(source))?.mime || "text/plain"
        res.contentType(mimeType)
        res.send(source)

    app.get '/api/lastComments', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.userKey()
            res.status(403).send('No permissions')
            return
        res.json(await SubmitComment.findLastNotViewedByUser(req.user?.userKey()))

    app.get '/api/comments/:page', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.userKey()
            res.status(403).send('No permissions')
            return
        page = req.params.page
        res.json(await SubmitComment.findByUserAndPage(req.user?.userKey(), page))

    app.get '/api/commentPages', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.userKey()
            res.status(403).send('No permissions')
            return
        res.json(await SubmitComment.findPagesCountByUser(req.user?.userKey()))

    app.get '/api/lastCommentsByProblem/:problem', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        res.json(await SubmitComment.findLastByProblem(req.params.problem))

    app.get '/api/bestSubmits/:problem', ensureLoggedIn, wrap (req, res) ->
        allowed = false
        if req.user?.admin
            allowed = true
        else if req.user?.userKey()
            result = await Result.findByUserAndTable(req.user?.userKey(), req.params.problem)
            allowed = result && result.solved > 0
        if not allowed
            res.status(403).send('No permissions')
            return
        res.json(await Submit.findBestByProblem(req.params.problem, 5))

    app.post '/api/setOutcome/:submitId', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        await setOutcome(req, res)
        res.send('OK')

    app.post '/api/setQuality/:submitId/:quality', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        submit = await Submit.findById(req.params.submitId)
        if not submit
            res.status(404).send('Submit not found')
            return
        submit.quality = req.params.quality
        await submit.save()
        res.send('OK')

    app.post '/api/setCommentViewed/:commentId', ensureLoggedIn, wrap (req, res) ->
        comment = await SubmitComment.findById(req.params.commentId)
        if ""+req.user?.userKey() != "" + comment?.userId
            res.status(403).send('No permissions')
            return
        comment.viewed = true
        await comment.save()
        res.send('OK')

    app.post '/api/moveUserToGroup/:userId/:groupName', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        user = await User.findById(req.params.userId)
        if not user
            res.status(400).send("User not found")
            return
        newGroup = req.params.groupName
        if newGroup != "none"
            await user.setUserList(newGroup)
        res.send('OK')

    app.post '/api/forceSetUserList/:userId/:groupName', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        user = await User.findById(req.params.userId)
        if not user
            res.status(400).send("User not found")
            return
        newGroup = req.params.groupName
        if newGroup != "none"
            await user.forceSetUserList(newGroup)
        res.send('OK')

    app.post '/api/setDormant/:userId', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        user = await User.findById(req.params.userId)
        if not user
            res.status(400).send("User not found")
            return
        await user.setDormant(true)
        res.send('OK')

    app.post '/api/setActivated/:userId', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        user = await User.findById(req.params.userId)
        if not user
            res.status(400).send("User not found")
            return
        await user.setActivated(req.body?.value)
        if req.body?.value then await user.setDormant(false)
        res.send('OK')

    app.post '/api/editMaterial/:id', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        material = await Material.findById(req.params.id)
        logger.info("Updating material #{material._id}")
        material.content = req.body.content
        material.title = req.body.title
        material.force = true
        await material.upsert()
        res.send('OK')

    app.post '/api/resetYear', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return

        runForUser = (user) ->
            userPrivate = await UserPrivate.findById(user._id)
            registeredUser = await RegisteredUser.findByKey(user._id)
            if registeredUser.admin or (user.userList == "stud" and userPrivate.paidTill > new Date())
                logger.info("Will not move user #{user._id} to unknown group")
                return
            await user.setActivated(false)
            logger.info("Deactivate user #{user._id}")

        users = await User.findAll()
        for user in users
            runForUser(user)
        res.send('OK')

    app.get '/api/updateResults/:user', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        await User.updateUser(req.params.user)
        res.send('OK')

    app.get '/api/updateAllResults', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        User.updateAllUsers()
        res.send('OK')

    app.get '/api/updateAllAllResults', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        User.updateAllUsers(undefined, true)
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

    app.get '/api/updateAllGraduateYears', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        User.updateAllGraduateYears()
        res.send('OK')

    app.get '/api/downloadSubmits/:user', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        await downloadSubmits.runForUser(req.params.user, 100, 1e9)
        res.send('OK')

    app.get '/api/downloadSubmitsForUserAndProblem/:user/:problem', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        await downloadSubmits.runForUserAndProblem(req.params.user, req.params.problem, undefined, true)
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
        user = await InformaticsUser.getUser(username, password)
        result = await user.getData()
        res.json(result)

    app.post '/api/codeforces/userData', wrap (req, res) ->
        username = req.body.username
        password = req.body.password
        try
            user = await LoggedCodeforcesUser.getUser(username, password)
            res.json({status: true})
        catch
            res.json({status: false})

    app.get '/api/downloadingStats', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        stats = getStats()
        stats.ip = JSON.parse(await download 'https://api.ipify.org/?format=json')["ip"]
        res.json(stats)
