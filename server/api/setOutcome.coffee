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

parseRunId = (runid) ->
    if runid.includes("r")
        [fullSubmitId, contest, run, problem] = runid.match(/(\d+)r(\d+)(p\d+)/)
    else
        [fullSubmitId, run, problem] = runid.match(/(\d+)(p\d+)/)
        contest = undefined
    return [fullSubmitId, contest, run, problem]

decodeComment = (comment) ->
    entities.decode(comment.text || comment)
storeToDatabase = (req, res) ->
    [fullSubmitId, contest, runId, problemId] = parseRunId(req.params.submitId)
    if contest
        runId = contest + "r" + runId
    submit = await Submit.findById(req.params.submitId)
    problem = await Problem.findById(problemId)
    logger.info("Store to database #{runId} #{problemId} #{problem?._id}")
    if req.body.result in ["AC", "IG", "DQ"]
        logger.info("Force-storing to database result #{req.params.submitId}")
        submit.outcome = req.body.result
        submit.force = true
        submit.calculateHashes()
    if req.body.comment
        reviewer = await User.findById(req.user.userKey())
        if not (req.body.comment in submit.comments.map(decodeComment))
            comment = entities.encode(req.body.comment)
            logger.info("Force-storing to database comment for #{req.params.submitId}")
            rndId = Math.floor(Math.random() * 1000000)
            newComment = new SubmitComment
                _id: "_#{rndId}r#{runId}"
                problemId: problemId
                problemName: problem.name
                userId: submit.user
                text: comment
                time: new Date()
                outcome: submit.outcome
                reviewer: reviewer?.name
            await newComment.upsert()
            submit.comments.push({text: comment, reviewer: reviewer?.name})
    await submit.upsert()
    dirtyResults = {}
    dirtyUsers = {}
    await setDirty(submit, dirtyResults, dirtyUsers)
    await User.updateUser(submit.user, dirtyResults)

export default setOutcome = (req, res) ->
    if req.body.result or req.body.comment
        await storeToDatabase(req, res)
