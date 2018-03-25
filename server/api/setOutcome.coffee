Entities = require('html-entities').XmlEntities
entities = new Entities()

import User from '../models/user'
import Submit from '../models/submit'
import Problem from '../models/problem'
import SubmitComment from '../models/SubmitComment'
import InformaticsUser from '../informatics/InformaticsUser'

import {runForUserAndProblem} from '../cron/downloadSubmits'

import logger from '../log'

postToInformatics = (req, res) ->
    _debug_marker = {qwe: '38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38_38'}
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
            _debug_marker = {qwe: '39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39_39'}
            await adminUser.download(href, {maxAttempts: 1})
    finally
        if req.body.comment
            href = "http://informatics.mccme.ru/py/comment/add"
            body =
                run_id: run
                contest_id: contest
                comment: req.body.comment
                lines: ""
            _debug_marker = {qwe: '40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40_40'}
            await adminUser.download(href, {
                method: 'POST',
                headers: {'Content-Type': "application/x-www-form-urlencoded; charset=UTF-8"},
                form: body,
                followAllRedirects: true
                maxAttempts: 1
            })

updateData = (req, res) ->
    [fullSubmitId, contest, run, problem] = req.params.submitId.match(/(\d+)r(\d+)p(\d+)/)
    _debug_marker = {qwe: '41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41_41'}
    submit = await Submit.findById(req.params.submitId)
    _debug_marker = {qwe: '42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42'}
    await runForUserAndProblem(submit.user, "p" + problem)
    _debug_marker = {qwe: '43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43_43'}
    submit = await Submit.findById(req.params.submitId)
    if req.body.result and submit.outcome != req.body.result
        return false
    if req.body.comment
        comment = entities.encode(req.body.comment)
        if not (comment in submit.comments)
            return false
    return true


storeToDatabase = (req, res) ->
    [fullSubmitId, runId, problemId] = req.params.submitId.match(/(\d+r\d+)(p\d+)/)
    _debug_marker = {qwe: '44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44'}
    submit = await Submit.findById(req.params.submitId)
    _debug_marker = {qwe: '45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45_45'}
    problem = await Problem.findById(problemId)
    if req.body.result in ["AC", "IG", "DQ"]
        logger.info("Force-storing to database result #{req.params.submitId}")
        submit.outcome = req.body.result
        submit.force = true
    if req.body.comment
        if not (req.body.comment in submit.comments.map(entities.decode))
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
            _debug_marker = {qwe: '46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46_46'}
            await newComment.upsert()
            submit.comments.push(comment)
    _debug_marker = {qwe: '47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47_47'}
    await submit.upsert()
    _debug_marker = {qwe: '48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48_48'}
    await updateData(req, res)  # to store comment with proper outcome
    _debug_marker = {qwe: '49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49_49'}
    await User.updateUser(submit.user)

export default setOutcome = (req, res) ->
    try
        _debug_marker = {qwe: '50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50_50'}
        await postToInformatics(req, res)
    catch e
        logger.info "Can't post to informatics ", req.params.submitId
        logger.info e.message
    success = false
    try
        _debug_marker = {qwe: '51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51_51'}
        success = await updateData(req, res)
    catch e
        logger.info "Can't update informatics status ", req.params.submitId
        logger.info e.message
        success = false
    if not success and (req.body.result or req.body.comment)
        _debug_marker = {qwe: '52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52_52'}
        await storeToDatabase(req, res)
    res.send('OK')
