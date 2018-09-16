Entities = require('html-entities').XmlEntities
entities = new Entities()

import User from '../models/user'
import Submit from '../models/submit'
import Problem from '../models/problem'
import SubmitComment from '../models/SubmitComment'

import getTestSystem from '../testSystems/TestSystemRegistry'

import {runForUserAndProblem} from '../cron/downloadSubmits'

import logger from '../log'

postToServer = (req, res) ->
    submitId = req.params.submitId
    outcome = req.body.result
    comment = req.body.comment

    server = getTestSystem("ejudge")
    server.setOutcome(submitId, outcome, comment)


updateData = (req, res) ->
    [fullSubmitId, contest, run, problem] = req.params.submitId.match(/(.+)r(.+)p(.+)/)
    submit = await Submit.findById(req.params.submitId)
    await runForUserAndProblem(submit.user, problem)
    submit = await Submit.findById(req.params.submitId)
    if req.body.result and submit.outcome != req.body.result
        return false
    if req.body.comment
        comment = entities.encode(req.body.comment)
        if not (comment in submit.comments)
            return false
    return true


storeToDatabase = (req, res) ->
    [fullSubmitId, contest, run, problemId] = req.params.submitId.match(/(.+)r(.+)p(.+)/)
    submit = await Submit.findById(req.params.submitId)
    problem = await Problem.findById(problemId)
    if req.body.result in ["AC", "IG", "DQ"]
        logger.info("Force-storing to database result #{req.params.submitId}")
        submit.outcome = req.body.result
        submit.force = true
    if req.body.comment
        comment = req.body.comment.trimRight()
        if not (comment in submit.comments.map(entities.decode))
            comment = entities.encode(comment)
            logger.info("Force-storing to database comment for #{req.params.submitId}")
            rndId = Math.floor(Math.random() * 1000000)
            newComment = new SubmitComment
                _id: "_#{rndId}r#{req.params.submitId}"
                problemId: problemId
                problemName: problem.name
                userId: submit.user
                text: comment
                time: new Date()
                outcome: submit.outcome
            await newComment.upsert()
            submit.comments.push(comment)
    await submit.upsert()
    await updateData(req, res)  # to store comment with proper outcome
    await User.updateUser(submit.user)

export default setOutcome = (req, res) ->
    try
        await postToServer(req, res)
    catch e
        logger.info "Can't post to server ", req.params.submitId
        logger.info e.message
    success = false
    try
        success = await updateData(req, res)
    catch e
        logger.info "Can't update server status ", req.params.submitId
        logger.info e.message
        success = false
    if not success and (req.body.result or req.body.comment)
        await storeToDatabase(req, res)
