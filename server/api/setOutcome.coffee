import User from '../models/user'
import Submit from '../models/submit'
import Problem from '../models/problem'
import SubmitComment from '../models/SubmitComment'
import InformaticsUser from '../informatics/InformaticsUser'

import logger from '../log'

postToInformatics = (req, res) ->
    adminUser = await InformaticsUser.findAdmin()
    [fullSubmitId, contest, run, problem] = req.params.submitId.match(/(\d+)r(\d+)p(\d+)/)
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
    outcomeCode = undefined
    if req.body.result == "AC"
        outcomeCode = 8
    if req.body.result == "IG"
        outcomeCode = 9
    if outcomeCode
        href = "http://informatics.mccme.ru/py/run/rejudge/#{contest}/#{run}/#{outcomeCode}"
        await adminUser.download href

storeToDatabase = (req, res) ->
    [fullSubmitId, runId, problemId] = req.params.submitId.match(/(\d+r\d+)p(\d+)/)
    submit = await Submit.findById(req.params.submitId)
    problem = await Problem.findById(problemId)
    if req.body.comment
        rndId = Math.floor(Math.random() * 1000000)
        newComment = new SubmitComment
            _id: "_#{rndId}r#{runId}"
            problemId: problemId
            problemName: problem.name
            userId: submit.user
            text: req.body.comment
            time: new Date()
            outcome: outcome
        await newComment.upsert()
        submit.comments.push(req.body.comment)
    if req.body.result in ["AC", "IG"]
        submit.outcome = req.body.result
        submit.force = true
    await submit.upsert()
    await User.updateUser(submit.user)

export default setOutcome = (req, res) ->
    await postToInformatics(req, res)
    await storeToDatabase(req, res)
    res.send('OK')
