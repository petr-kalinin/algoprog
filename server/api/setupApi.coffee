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
import ACHIEVES from '../../client/lib/achieves'
import {getYear} from '../../client/lib/graduateYearToClass'
import {unpaidBlocked} from '../../client/lib/isPaid'

import {levelVersion} from '../calculations/calculateRatingEtc'
import {getTables, getUserResult} from '../calculations/updateTableResults'

import * as downloadSubmits from "../cron/downloadSubmits"
import findSimilarSubmits from '../hashes/findSimilarSubmits'
import * as groups from '../informatics/informaticsGroups'
import InformaticsUser from '../informatics/InformaticsUser'

import download, {getStats} from '../lib/download'
import normalizeCode from '../lib/normalizeCode'
import {addIncome, makeReceiptLink} from '../lib/npd'
import setDirty from '../lib/setDirty'
import sleep from '../lib/sleep'

import {allTables} from '../materials/data/tables'
import downloadMaterials from '../materials/downloadMaterials'
import notify from '../metrics/notify'

import BlogPost from '../models/BlogPost'
import Calendar from '../models/Calendar'
import Checkin, {MAX_CHECKIN_PER_SESSION} from '../models/Checkin'
import FindMistake from '../models/FindMistake'
import Material from '../models/Material'
import Payment from '../models/Payment'
import Problem from '../models/problem'
import RegisteredUser from '../models/registeredUser'
import Result from '../models/result'
import Submit from '../models/submit'
import SubmitComment from '../models/SubmitComment'
import Table from '../models/table'
import TableResults from '../models/TableResults'
import User from '../models/user'
import UserPrivate from '../models/UserPrivate'

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
        sortBySolved = (a, b) ->
            if a.user.active != b.user.active
                return if a.user.active then -1 else 1
            if a.total.solved != b.total.solved
                return b.total.solved - a.total.solved
            if a.total.attempts != b.total.attempts
                return a.total.attempts - b.total.attempts
            return 0

        sortByLevelAndRating = (a, b) ->
            return User.sortByLevelAndRating(a.user, b.user)

        userList = req.params.userList
        table = req.params.table
        data = []
        users = await User.findByList(userList)
        tables = await getTables(table)
        #[users, tables] = await awaitAll([users, tables])
        getTableResults = (user, tableName, tables) ->
            sumTable = await TableResults.findByUserAndTable(user._id, tableName)
            if sumTable
                return
                    results: sumTable?.data?.results
                    total : sumTable?.data?.total
            else
                return getUserResult(user._id, tables, 1)
        for user in users
            data.push getTableResults user, table, tables
        results = await awaitAll(data)
        results = ({r..., user: users[i]} for r, i in results when r)
        results = results.sort(if table == "main" then sortByLevelAndRating else sortBySolved)
        res.json(results)

    app.get '/api/fullUser/:id', wrap (req, res) ->
        userId = req.params.id
        tables = []
        for t in allTables when t != 'main'
          tables.push(getTables(t))
        tables = await awaitAll(tables)

        user = await User.findById(userId)
        calendar = await Calendar.findById(userId)
        if not user
            return null
        results = []
        for t in tables
            results.push(getUserResult(user._id, t, 1))
        results = await awaitAll(results)
        results = (r.results for r in results when r)
        result =
            user: user.toObject()
            results: results
            calendar: calendar?.toObject()

        userPrivate = {}
        if req.user?.admin or ""+req.user?.userKey() == ""+userId
            userPrivate = (await UserPrivate.findById(userId))?.toObject() || {}
        result.user = {result.user..., userPrivate...}
        res.json(result)

    app.get '/api/users/:userList', wrap (req, res) ->
        res.json(await User.findByList(req.params.userList))

    app.get '/api/users/withAchieve/:achieve', wrap (req, res) ->
        achieve = req.params.achieve
        if not (achieve of ACHIEVES)
            res.status(400).send('Unknown achieve')
            return
        users = await User.findByAchieve(achieve)
        res.json(users)

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

    app.get '/api/submitsForFindMistake/:user/:findMistake', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin and ""+req.user?.userKey() != ""+req.params.user
            res.status(403).send('No permissions')
            return
        fm = await FindMistake.findById(req.params.findMistake)
        allowed = false
        if req.user.admin 
            allowed = true
        else 
            result = await Result.findByUserAndTable(req.params.user, fm.problem)
            allowed = result && result.solved > 0
        if not allowed
            res.status(403).send('No permissions')
            return
        submits = await Submit.findByUserAndFindMistake(req.params.user, req.params.findMistake)
        submit0 = (await Submit.findById(fm.submit)).toObject()
        submit0 =
            _id: submit0._id
            time: "_orig"
            problem: submit0.problem
            outcome: submit0.outcome
            source: submit0.source
            sourceRaw: submit0.sourceRaw
            language: submit0.language
            comments: []
            results: submit0.results
        submits = submits.map((submit) -> submit.toObject())
        submits.splice(0, 0, submit0)
        if not req.user?.admin
            submits = submits.map(hideTests)
        submits = submits.map(expandSubmit)
        submits = await awaitAll(submits)
        res.json(submits)

    app.ws '/wsapi/submitsForFindMistake/:user/:findMistake', (ws, req, next) ->
        addMongooseCallback ws, 'update_submit', req.user?.userKey(), ->
            if not req.user?.admin and ""+req.user?.userKey() != ""+req.params.user
                return
            fm = await FindMistake.findById(req.params.findMistake)
            allowed = false
            if req.user.admin 
                allowed = true
            else 
                result = await Result.findByUserAndTable(req.params.user, fm.problem)
                allowed = result && result.solved > 0
            if not allowed
                return
            submits = await Submit.findByUserAndFindMistake(req.params.user, req.params.findMistake)
            submit0 = (await Submit.findById(fm.submit)).toObject()
            submit0 =
                _id: submit0._id
                time: "_orig"
                problem: submit0.problem
                outcome: submit0.outcome
                source: submit0.source
                sourceRaw: submit0.sourceRaw
                language: submit0.language
                comments: []
                results: submit0.results
            submits = submits.map((submit) -> submit.toObject())
            submits.splice(0, 0, submit0)
            if not req.user?.admin
                submits = submits.map(hideTests)
            submits = submits.map(expandSubmit)
            submits = await awaitAll(submits)
            ws.send JSON.stringify(submits)

    app.get '/api/submitsByDay/:user/:day', wrap (req, res) ->
        submits = await Submit.findByUserAndDayWithFindMistakeAny(req.params.user, req.params?.day)
        submits = submits.map((submit) -> submit.toObject())
        submits = submits.map(hideTests)
        submits = submits.map(expandSubmit)
        submits = await awaitAll(submits)
        submits = submits.map((submit) ->
              _id: submit._id
              problem: submit.problem
              user: submit.user
              time: submit.time
              outcome: submit.outcome
              language: submit.language
              fullProblem: submit.fullProblem
        )
        res.json(submits)

    app.get '/api/material/:id', wrap (req, res) ->
        res.json(await Material.findById(req.params.id))

    app.get '/api/lastBlogPosts', wrap (req, res) ->
        res.json(await BlogPost.findLast(5, 1000 * 60 * 60 * 24 * 60))

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

    app.get '/api/userResultsForFindMistake/:userId', wrap (req, res) ->
        results = (await Result.findByUserWithFindMistakeSet(req.params.userId))
        json = {}
        for r in results
            r = r.toObject()
            json[r.findMistake] = r
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

    app.get '/api/similarSubmits/:id', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        submit = (await Submit.findById(req.params.id)).toObject()
        similar = await findSimilarSubmits(submit, 5)
        similar = similar.map((submit) -> submit.toObject())
        similar = similar.map(expandSubmit)
        similar = await awaitAll(similar)
        similar = similar.map (submit) ->
            return
                _id: submit._id
                time: submit.time
                user: submit.user
                problem: submit.problem
                source: submit.source
                sourceRaw: submit.sourceRaw
                fullUser: submit.fullUser
                fullProblem: submit.fullProblem
                outcome: submit.outcome
                language: submit.language
        res.json(similar)

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

    app.get '/api/checkins', wrap (req, res) ->
        checkins = (
            { 
                checkins: await Checkin.findBySession(i)
                max: MAX_CHECKIN_PER_SESSION[i]
            } for i in [0..1])
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

    app.get '/api/recentReceipt/:user', wrap (req, res) ->
        if not req.user?.admin and ""+req.user?.informaticsId != ""+req.params.user
            res.status(403).json({error: 'No permissions'})
            return
        for i in [1..10]
            payment = await Payment.findLastReceiptByUserId(req.params.user)
            if payment and new Date() - payment.time < 24 * 60 * 60 * 1000
                res.json({receipt: makeReceiptLink(payment.receipt)})
                return
            await sleep(1000)
        res.json({})

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

    app.get '/api/randomizeEjudgePasswords', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        User.randomizeEjudgePasswords()
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

    app.post '/api/codeforces/userData', wrap (req, res) ->
        username = req.body.username
        password = req.body.password
        try
            user = await LoggedCodeforcesUser.getUser(username, password)
            res.json({status: true})
        catch
            res.json({status: false})

    app.get '/api/findMistakeList/:user/:page', wrap (req, res) ->
        allowed = false
        user = null
        if req.params.user == "undefined"
            allowed = true
        else if req.user?.admin or ""+req.user?.informaticsId == ""+req.params.user
            allowed = true
            user = req.params.user
        if not allowed
            res.status(403).json({error: 'No permissions'})
            return
        mistakes = await FindMistake.findApprovedByNotUser(user, req.params.page)
        mistakes = mistakes.map (mistake) -> 
            expandFindMistake(mistake, req.user?.admin, user)
        mistakes = await awaitAll(mistakes)
        mistakes = (m for m in mistakes when m)
        res.json(mistakes)

    app.get '/api/findMistakePages/:user', wrap (req, res) ->
        allowed = false
        user = null
        if req.params.user == "undefined"
            allowed = true
        else if req.user?.admin or ""+req.user?.informaticsId == ""+req.params.user
            allowed = true
            user = req.params.user
        res.json(await FindMistake.findPagesCountForApprovedByNotUser(user))

    app.get '/api/findMistakeProblemList/:user/:problem/:page', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin and ""+req.user?.informaticsId != ""+req.params.user
            res.status(403).json({error: 'No permissions'})
            return
        mistakes = await FindMistake.findApprovedByNotUserAndProblem(req.params.user, req.params.problem, req.params.page)
        mistakes = mistakes.map (mistake) -> 
            expandFindMistake(mistake, req.user?.admin, req.params.user)
        mistakes = await awaitAll(mistakes)
        mistakes = (m for m in mistakes when m)
        res.json(mistakes)

    app.get '/api/findMistakeProblemPages/:user/:problem', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.userKey()
            res.status(403).send('No permissions')
            return
        res.json(await FindMistake.findPagesCountForApprovedByNotUserAndProblem(req.params.user, req.params.problem))

    app.get '/api/findMistake/:id', ensureLoggedIn, wrap (req, res) ->
        mistake = await FindMistake.findById(req.params.id)
        mistake = await expandFindMistake(mistake, req.user?.admin, req.user?.userKey())
        res.json(mistake)

    app.get '/api/downloadingStats', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        stats = getStats()
        stats.ip = JSON.parse(await download 'https://api.ipify.org/?format=json')["ip"]
        res.json(stats)

    app.get '/api/approveFindMistake', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        while true
            mistake = await FindMistake.findOneNotApproved()
            if not mistake
                res.json({})
                return
            submits = [await Submit.findById(mistake.submit), await Submit.findById(mistake.correctSubmit)]
            if not submits[0] || not submits[1]
                console.log "Bad findmistake ", mistake._id, mistake.submit, mistake.correctSubmit
                await mistake.setBad()
                continue
            submits = submits.map(expandSubmit)
            submits = await awaitAll(submits)
            count = await FindMistake.findNotApprovedCount()
            res.json({mistake, submits, count})
            return

    app.post '/api/setApproveFindMistake/:id', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        approve = req.body.approve
        mistake = await FindMistake.findById(req.params.id)
        await mistake.setApprove(approve)
        res.send('OK')

    app.get '/api/markUsers', ensureLoggedIn, wrap (req, res) ->
        url = req.query.url
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        text = await download url    
        users = await User.find({})
        for user in users
            name = user.name.replace("е", "[е`]").replace("ё", "[е`]").replace("`","ё")
            name1 = name
            name2 = name.split(' ').reverse().join(' ')
            re = XRegExp("(^|[^\\p{L}])((#{name1})|(#{name2}))($|[^\\p{L}])", "iug")
            context = {}
            el = <StaticRouter context={context}><UserNameRaw user={user} theme={"light"}/></StaticRouter>
            html = renderToString(el)
            html = html.replace("/user/", "https://algoprog.ru/user/")
            text = text.replace(re, "$1#{html}$5")
        # assume that if page contains <head>, then it is html
        text = text.replace("<head>", '<head><link rel="stylesheet" href="https://algoprog.ru/bundle.css"/><base href="' + url + '"/>')
        res.send(text)

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
        try
            receipt = await addIncome("Оплата занятий на algoprog.ru", +userPrivate.price)
            notify "Добавлен чек (#{req.body.OrderId}, #{userPrivate.price}р.):\n#{user.name}: http://algoprog.ru/user/#{userId}\n" + makeReceiptLink(receipt) 
        catch e
            notify "Ошибка добавления чека (#{req.body.OrderId}, #{userPrivate.price}р.):\n#{user.name}: http://algoprog.ru/user/#{userId}\n" + e
            receipt = "---"
        logger.info("paymentNotify #{req.body.OrderId}: ok, new paidTill: #{newPaidTill}, receipt: #{receipt}")
        payment.processed = true
        payment.newPaidTill = newPaidTill
        payment.receipt = receipt
        await payment.upsert()
        res.send('OK')

    app.get '/api/makeFakeUsers', ensureLoggedIn, wrap (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
            return
        for i in [0..14]
            console.log "User #{i}"
            newUser = new User(
                _id: "fake#{i}",
                name: "Fake Fake",
                userList: "zaoch",
                activated: true,
                lastActivated: new Date()
                registerDate: new Date()
            )
            await newUser.upsert()
            newRegisteredUser = new RegisteredUser({
                "fake#{i}",
                informaticsId: "fake#{i}",
                "fake#{i}",
                "fake#{i}",
                "fake",
                "",
                "",
                ""
                admin: false
            })
            RegisteredUser.register newRegisteredUser, req.body.password, (err) -> 

            problems = await Problem.find {}
            for problem in problems
                #console.log "Problem #{problem._id} level #{problem.level}"
                level = problem.level
                version = levelVersion(problem.level)
                #console.log "Problem #{problem._id} version #{version.major} #{version.minor}"
                solved = true
                if problem._id == "p2938"
                    solved = true
                else if level.slice(0,3) in ["reg", "roi"]
                    solved = false
                else if version.major > i
                    solved = false
                else if version.minor in ['В', 'Г']
                    p = 1 - Math.pow(0.5, i - version.major + 1)
                    if version.minor == 'Г'
                        p *= 2.0/3
                    rng = seedrandom("#{problem._id}")
                    #console.log "Problem #{problem._id} p=#{p}"
                    if rng() > p
                        solved = false
                #console.log "Solved= #{solved}"
                submit = new Submit
                    _id: "fake#{i}r#{problem._id}" ,
                    time: new Date(),
                    user: "fake#{i}",
                    userList: "zaoch",
                    problem: problem._id,
                    outcome: if solved then "AC" else "IG"
                    source: "fake"
                    sourceRaw: "fake"
                    language: "fake"
                    comments: []
                    results: []
                    force: false
                    testSystemData: []
                await submit.upsert()
            
            await User.updateUser(newUser._id)
        res.send('OK')
