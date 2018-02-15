import User from '../models/user'
import Submit from '../models/submit'
import Problem from '../models/problem'
import SubmitComment from '../models/SubmitComment'
import InformaticsUser from '../informatics/InformaticsUser'

import {runForUserAndProblem} from '../cron/downloadSubmits'

import logger from '../log'

postToInformatics = (req, res) ->
    adminUser = await InformaticsUser.findAdmin()
    [fullSubmitId, contest, run, problem] = req.params.submitId.match(/(\d+)r(\d+)p(\d+)/)
    outcomeCode = undefined
    if req.body.result == "AC"
        outcomeCode = 8
    if req.body.result == "IG"
        outcomeCode = 9
    if req.body.result == "DQ"
        outcomeCode = 10
    try
        if outcomeCode
            href = "http://informatics.mccme.ru/py/run/rejudge/#{contest}/#{run}/#{outcomeCode}"
            await adminUser.download href
    finally
        if req.body.comment
            href = "http://informatics.mccme.ru/py/comment/add"
            body =
                run_id: run
                contest_id: contest
                comment: req.body.comment
                lines: ""
            await adminUser.download(href, {
                method: 'POST',
                headers: {'Content-Type': "application/x-www-form-urlencoded; charset=UTF-8"},
                form: body,
                followAllRedirects: true
            })

updateData = (req, res) ->
    [fullSubmitId, contest, run, problem] = req.params.submitId.match(/(\d+)r(\d+)p(\d+)/)
    submit = await Submit.findById(req.params.submitId)
    await runForUserAndProblem(submit.user, "p" + problem)
    submit = await Submit.findById(req.params.submitId)
    return submit.outcome == req.body.result

storeToDatabase = (req, res) ->
    logger.info("Force-storing to database result #{req.params.submitId}")
    [fullSubmitId, runId, problemId] = req.params.submitId.match(/(\d+r\d+)(p\d+)/)
    submit = await Submit.findById(req.params.submitId)
    problem = await Problem.findById(problemId)
    if req.body.result in ["AC", "IG", "DQ"]
        submit.outcome = req.body.result
        submit.force = true
    if req.body.comment and not (req.body.comment in submit.comments)
        logger.info("Force-storing to database comment for #{req.params.submitId}")
        rndId = Math.floor(Math.random() * 1000000)
        newComment = new SubmitComment
            _id: "_#{rndId}r#{runId}"
            problemId: problemId
            problemName: problem.name
            userId: submit.user
            text: req.body.comment
            time: new Date()
            outcome: submit.outcome
        await newComment.upsert()
        submit.comments.push(req.body.comment)
    await submit.upsert()
    await updateData(req, res)  # to store comment with proper outcome
    await User.updateUser(submit.user)

export default setOutcome = (req, res) ->
    success = false
    try
        await postToInformatics(req, res)
        success = await updateData(req, res)
    catch e
        logger.info "Can't update informatics status ", req.params.submitId
        logger.info e.message
    if not success and (req.body.result or req.body.comment)
        await storeToDatabase(req, res)
    res.send('OK')
