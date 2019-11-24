connectEnsureLogin = require('connect-ensure-login')
passport = require('passport')
iconv = require('iconv-lite')
Entities = require('html-entities').XmlEntities
sha256 = require('sha256')
fileType = require('file-type')
deepcopy = require('deepcopy')
moment = require('moment')

import User from '../models/user'
import UserPrivate from '../models/UserPrivate'
import Submit from '../models/submit'
import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'
import SubmitComment from '../models/SubmitComment'
import RegisteredUser from '../models/registeredUser'
import Material from '../models/Material'
import BlogPost from '../models/BlogPost'
import Payment from '../models/Payment'
import Checkin, {MAX_CHECKIN_PER_SESSION} from '../models/Checkin'

import getTestSystem from '../../server/testSystems/TestSystemRegistry'

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

import download from '../lib/download'
import {getStats} from '../lib/download'
import normalizeCode from '../lib/normalizeCode'
import setDirty from '../lib/setDirty'

import {unpaidBlocked} from '../../client/lib/isPaid'
import awaitAll from '../../client/lib/awaitAll'

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

hideTests = (submit, reqUser) ->
    hideOneTest = (test) ->
        res = {}
        for field in ["string_status", "status", "max_memory_used", "time", "real_time"]
            res[field] = test[field]
        return res

    if submit.results?.tests
        for key, test of submit.results.tests
            submit.results.tests[key] = hideOneTest(test)
    return submit

createSubmit = (problemId, userId, language, codeRaw, draft) ->
    codeRaw = iconv.decode(new Buffer(codeRaw), "latin1")
    codeRaw = normalizeCode(codeRaw)
    code = entities.encode(codeRaw)
    if not draft
        allSubmits = await Submit.findByUserAndProblem(userId, problemId)
        for s in allSubmits
            if s.outcome != "DR" and s.source == code
                throw "duplicate"
    time = new Date
    timeStr = +time
    submit = new Submit
        _id: "#{userId}r#{timeStr}#{problemId}" ,
        time: time,
        user: userId,
        problem: problemId,
        outcome: if draft then "DR" else "PS"
        source: code
        sourceRaw: codeRaw
        language: language
        comments: []
        results: []
        force: false
    await submit.upsert()
    dirtyResults = {}
    await setDirty(submit, dirtyResults, {})
    await User.updateUser(submit.user, dirtyResults)


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
        userPrivate = (await UserPrivate.findById(req.user.userKey())?.toObject) || {}
        user = (await User.findById(req.user.userKey())?.toObject) || {}
        if unpaidBlocked({user..., userPrivate...})
            res.json({unpaid: true})
            return
        try
            await createSubmit(req.params.problemId, req.user.userKey(), req.body.language, req.body.code, req.body.draft)
        catch e
            res.json({error: e})
            return
        #testSystem = await getTestSystem("informatics")
        #await testSystem.submitWithFormData(req.user, req.params.problemId, req.get('Content-Type'), req.body)
        res.json({submit: true})

    app.get '/api/me', ensureLoggedIn, wrap (req, res) ->
        user = JSON.parse(JSON.stringify(req.user))
        delete user.informaticsPassword
        res.json user

    app.get '/api/myUser', ensureLoggedIn, wrap (req, res) ->
        id = req.user.informaticsId
        user = (await User.findById(id))?.toObject() || {}
        userPrivate = (await UserPrivate.findById(id))?.toObject() || {}
        res.json({user..., userPrivate...})

    app.post '/api/user/:id/set', ensureLoggedIn, wrap (req, res) ->
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
        res.send('OK')

    app.post '/api/user/:id/setChocosGot', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        chocosGot = req.body.chocosGot
        user = await User.findById(req.params.id)
        await user.setChocosGot chocosGot
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

    app.get '/api/table/:userList/:table', wrap (req, res) ->
        res.json(await table(req.params.userList, req.params.table))

    app.get '/api/fullUser/:id', wrap (req, res) ->
        id = req.params.id
        result = await tableApi.fullUser(id)
        userPrivate = {}
        if req.user?.admin or ""+req.user?.userKey() == ""+req.params.id
            userPrivate = (await UserPrivate.findById(id))?.toObject() || {}
        result.user = {result.user..., userPrivate...}
        res.json(result)

    app.get '/api/users/:userList', wrap (req, res) ->
        res.json(await User.findByList(req.params.userList))

    app.post '/api/searchUser', ensureLoggedIn, wrap (req, res) ->
        addUserName = (user) ->
            fullUser = await User.findById(user.informaticsId)
            user.fullName = fullUser?.name
            user.registerDate = fullUser?.registerDate
            user.userList = fullUser?.userList

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
        result = result.filter((user) -> not user.dormant)
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

    app.get '/api/material/:id', wrap (req, res) ->
        res.json(await Material.findById(req.params.id))

    app.get '/api/lastBlogPosts', wrap (req, res) ->
        res.json(await BlogPost.findLast(5, 1000 * 60 * 60 * 24 * 60))

    app.get '/api/result/:id', wrap (req, res) ->
        result = (await Result.findById(req.params.id)).toObject()
        result.fullUser = await User.findById(result.user)
        result.fullTable = await Problem.findById(result.table)
        res.json(result)

    app.get '/api/userResults/:userId', wrap (req, res) ->
        results = (await Result.findByUser(req.params.userId))
        json = {}
        for r in results
            r = r.toObject()
            json[r._id] = r
        res.json(json)

    app.get '/api/submit/:id', ensureLoggedIn, wrap (req, res) ->
        res.status(404).send("Not found")
        return
        if not req.user?.admin and ""+req.user?.userKey() != ""+req.params.user
            res.status(403).send('No permissions')
            return
        submit = (await Submit.findById(req.params.id)).toObject()
        submit = hideTests(submit)
        submit = expandSubmit(submit)
        res.json(submit)

    app.get '/api/submitSource/:id', ensureLoggedIn, wrap (req, res) ->
        submit = await Submit.findById(req.params.id)
        if not req.user?.admin and ""+req.user?.userKey() != ""+submit.user
            res.status(403).send('No permissions')
            return
        mimeType = fileType(Buffer.from(submit.sourceRaw))?.mime || "text/plain"
        res.contentType(mimeType)
        res.send(submit.sourceRaw)

    app.get '/api/lastComments', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.userKey()
            res.status(403).send('No permissions')
            return
        res.json(await SubmitComment.findLastNotViewedByUser(req.user?.userKey()))

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
        console.log "Set comment viewed ", req.params.commentId, ""+req.user?.userKey(), "" + comment?.userId
        if ""+req.user?.userKey() != "" + comment?.userId
            res.status(403).send('No permissions')
            return
        comment.viewed = true
        await comment.save()
        res.send('OK')

    app.get '/api/checkins', wrap (req, res) ->
        checkins = (
            { 
                checkins: await Checkin.findBySession(i)
                max: MAX_CHECKIN_PER_SESSION[i]
            } for i in [0..2])
        for sessionCheckins in checkins
            sessionCheckins.checkins = await awaitAll(sessionCheckins.checkins.map((checkin) ->
                checkin = checkin.toObject()
                checkin.fullUser = await User.findById(checkin.user)
                return checkin
            ))
        res.json(checkins)

    app.post '/api/checkin/:user', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin and ""+req.user?.informaticsId != ""+req.params.user
            res.status(403).json({error: 'No permissions'})
            return
        session = req.body.session
        if session?
            session = +session
        user = ""+req.params.user
        logger.info "User #{user} checkin for session #{session}"
        if (session? and session != 0 and session != 1)
            res.status(400).json({error: "Strange session"})
            return
        if session?
            sessionCheckins = await Checkin.findBySession(session)
            if sessionCheckins.length >= MAX_CHECKIN_PER_SESSION[session]        
                res.status(403).json({error: "Нет мест"})
                return
        userCheckins = await Checkin.findByUser(user)
        for checkin in userCheckins
            await checkin.markDeleted()
        if session?
            checkin = new Checkin
                user: user
                session: session
            await checkin.upsert()
        res.json({ok: "OK"})

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
        adminUser = await InformaticsUser.findAdmin()

        runForUser = (user) ->
            await groups.moveUserToGroup(adminUser, user._id, "unknown")
            await user.setUserList("unknown")
            logger.info("Moved user #{user._id} to unknown group")

        users = await User.findAll()
        for user in users
            #if user.userList == "stud"
            #    continue
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
        await downloadSubmits.runForUser(req.params.user, 100, 1e9)
        res.send('OK')

    app.get '/api/downloadSubmitsForUserAndProblem/:user/:problem', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        await downloadSubmits.runForUserAndProblem(req.params.user, req.params.problem)
        res.send('OK')

    app.get '/api/downloadAllSubmits', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        downloadSubmits.runAll()
        res.send('OK')

    app.get '/api/calculateAllHashes', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        Submit.calculateAllHashes()
        res.send('OK')

    app.post '/api/informatics/userData', wrap (req, res) ->
        username = req.body.username
        password = req.body.password
        user = await InformaticsUser.getUser(username, password)
        result = await user.getData()
        res.json(result)

    app.get '/api/downloadingStats', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        stats = getStats()
        stats.ip = JSON.parse(await download 'https://api.ipify.org/?format=json')["ip"]
        res.json(stats)

    app.post '/api/paymentNotify', wrap (req, res) ->
        logger.info("paymentNotify #{req.body.OrderId}")
        data = deepcopy(req.body)
        token = data.Token
        delete data.Token
        data.Password = PASSWORD
        keys = (key for own key, value of data)
        keys.sort()
        str = ""
        for key in keys
            str += data[key]
        hash = sha256(str)
        if hash != token
            logger.warn("paymentNotify #{req.body.OrderId}: wrong token")
            res.status(403).send('Wrong token')
            return

        [userId, paidTillInOrder] = data.OrderId.split(":")
        success = data.Status == "CONFIRMED"

        payment = new Payment
            user: userId
            orderId: data.OrderId
            success: success
            processed: false
            payload: req.body
        await payment.upsert()

        if not success
            logger.info("paymentNotify #{req.body.OrderId}: unsuccessfull (#{data.Status})")
            res.send('OK')
            return
        user = await User.findById(userId)
        if not user
            logger.warn("paymentNotify #{req.body.OrderId}: unknown user")
            res.send('OK')
            return

        userPrivate = await UserPrivate.findById(userId)
        if not userPrivate
            userPrivate = new UserPrivate({_id: req.params.id})
        payment.oldPaidTill = userPrivate.paidTill
        expectedPaidTill = moment(userPrivate.paidTill).format("YYYYMMDD")
        if expectedPaidTill != paidTillInOrder
            logger.warn("paymentNotify #{req.body.OrderId}: wrong paid till (current is #{expectedPaidTill})")
            res.send('OK')
            return
        if +userPrivate.price * 100 != +data.Amount
            logger.warn("paymentNotify #{req.body.OrderId}: wrong amount (price is #{userPrivate.price}, paid #{data.Amount/100})")
            res.send('OK')
            return
        if not userPrivate.paidTill or new Date() - userPrivate.paidTill > 5 * 24 * 60 * 60 * 1000
            newPaidTill = new Date()
        else
            newPaidTill = userPrivate.paidTill
        newPaidTill = moment(newPaidTill).add(1, 'months').startOf('day').toDate()
        userPrivate.paidTill = newPaidTill
        await userPrivate.upsert()
        payment.processed = true
        payment.newPaidTill = newPaidTill
        await payment.upsert()
        logger.info("paymentNotify #{req.body.OrderId}: ok, new paidTill: #{newPaidTill}")
        res.send('OK')
