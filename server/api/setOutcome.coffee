Entities = require('html-entities').XmlEntities
entities = new Entities()

import User from '../models/user'
import Material from '../models/Material'
import Submit from '../models/submit'
import Problem from '../models/problem'
import SubmitComment from '../models/SubmitComment'
import {notifyUser} from "../lib/telegramBot"
import GROUPS from "../../client/lib/groups"

import getTestSystem from '../testSystems/TestSystemRegistry'

import {runForUserAndProblem} from '../cron/downloadSubmits'

import setDirty from '../lib/setDirty'

import logger from '../log'

generateMsg = (user, result, problemName, problemHref) ->
    msg = ""
    problemName = "'<a href='https://algoprog.ru/material/" + problemHref + "'>" + problemName + "</a>'"

    if user.getInterfaceLanguage() == "en"
        msg += "The solution for the " + problemName + " problem has been "

        if result == "AC"
            msg += "accepted"
        else if result == "IG"
            msg += "ignored"
        else if result == "DQ"
            msg += "disqualified"
        else
            msg += "commented"
    else
        msg += "Решение задачи " + problemName + " "

        if result == "AC"
            msg += "зачтено"
        else if result == "IG"
            msg += "проигнорировано"
        else if result == "DQ"
            msg += "дисквалифицировано"
        else
            msg += "прокомментировано"

    return msg

decodeComment = (comment) ->
    entities.decode(comment.text || comment)

storeToDatabase = (req, res) ->
    submit = await Submit.findById(req.params.submitId)
    problemId = submit.problem
    user = await User.findByIdWithTelegram(submit.user)
    lang = GROUPS[user.userList].lang
    material = await Material.findById(problemId + lang)
    logger.info("Store to database #{req.params.submitId} #{problemId} #{material._id}")
    msg = generateMsg(user, req.body.result, material.title, material._id)

    if req.body.result in ["AC", "IG", "DQ"]
        logger.info("Force-storing to database result #{req.params.submitId}")
        submit.outcome = req.body.result
        submit.force = true
        submit.calculateHashes()
        comments = await SubmitComment.findBySubmit(req.params.submitId)
        for c in comments
            c.outcome = submit.outcome
            await c.upsert()
    if req.body.comment
        reviewer = await User.findById(req.user.userKey())
        if not (req.body.comment in submit.comments.map(decodeComment))
            comment = entities.encode(req.body.comment)
            logger.info("Force-storing to database comment for #{req.params.submitId}")
            rndId = Math.floor(Math.random() * 1000000)
            newComment = new SubmitComment
                _id: "_#{rndId}r#{req.params.submitId}"
                submit: req.params.submitId
                problemId: problemId
                problemName: material.title
                userId: submit.user
                text: comment
                time: new Date()
                outcome: submit.outcome
                reviewer: reviewer?.name
            await newComment.upsert()
            submit.comments.push({text: comment, reviewer: reviewer?.name})
            msg += "\n" + comment

    await submit.upsert()
    dirtyResults = {}
    dirtyUsers = {}
    await setDirty(submit, dirtyResults, dirtyUsers)
    await User.updateUser(submit.user, dirtyResults)
    
    await notifyUser submit.user, msg

export default setOutcome = (req, res) ->
    if req.body.result or req.body.comment
        await storeToDatabase(req, res)
