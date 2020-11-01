Entities = require('html-entities').XmlEntities
entities = new Entities()

import User from '../models/user'
import Submit from '../models/submit'
import Problem from '../models/problem'
import SubmitComment from '../models/SubmitComment'

import getTestSystem from '../testSystems/TestSystemRegistry'

import {runForUserAndProblem} from '../cron/downloadSubmits'

import setDirty from '../lib/setDirty'

import logger from '../log'

storeToDatabase = (req, res) ->
    submit = await Submit.findById(req.params.submitId)
    problemId = submit.problem
    problem = await Problem.findById(problemId)
    logger.info("Store to database #{req.params.submitId} #{problemId} #{problem?._id}")
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
        if not (req.body.comment in submit.comments.map(entities.decode))
            comment = entities.encode(req.body.comment)
            logger.info("Force-storing to database comment for #{req.params.submitId}")
            rndId = Math.floor(Math.random() * 1000000)
            newComment = new SubmitComment
                _id: "_#{rndId}r#{req.params.submitId}"
                submit: req.params.submitId
                problemId: problemId
                problemName: problem.name
                userId: submit.user
                text: comment
                time: new Date()
                outcome: submit.outcome
            await newComment.upsert()
            submit.comments.push(comment)
    await submit.upsert()
    dirtyResults = {}
    dirtyUsers = {}
    await setDirty(submit, dirtyResults, dirtyUsers)
    await User.updateUser(submit.user, dirtyResults)

export default setOutcome = (req, res) ->
    if req.body.result or req.body.comment
        await storeToDatabase(req, res)
