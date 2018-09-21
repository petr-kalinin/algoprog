import User from '../models/user'
import Table from '../models/table'
import Result from '../models/result'
import Submit from '../models/submit'
import Problem from '../models/problem'

import addTotal from '../../client/lib/addTotal'
import isContestRequired from '../../client/lib/isContestRequired'

import logger from '../log'

updateResultsForTable = (userId, tableId, dirtyResults) ->
    if dirtyResults and (not ((userId + "::" + tableId) of dirtyResults))
        result = await Result.findByUserAndTable(userId, tableId)
        if result
            return result

    total = {}
    table = await Table.findById(tableId)
    for child in table.tables
        res = await updateResultsForTable(userId, child, dirtyResults)
        fullChild = await Table.findById(child)
        if not isContestRequired(fullChild?.name)
            res.required = 0
        total = addTotal(total, res, true)
    for prob in table.problems
        res = await updateResultsForProblem(userId, prob, dirtyResults)
        total = addTotal(total, res, true)

    logger.debug "updated result ", userId, tableId, total
    result = new Result({
        total...,
        user: userId,
        table: tableId
    })
    await result.upsert()
    return result

updateResultsForProblem = (userId, problemId, dirtyResults) ->
    if dirtyResults and (not ((userId + "::" + problemId) of dirtyResults))
        result = await Result.findByUserAndTable(userId, problemId)
        if result
            return result
    problem = await Problem.findById(problemId)
    submits = await Submit.findByUserAndProblem(userId, problemId)
    solved = 0
    ok = 0
    attempts = 0
    ignored = 0
    points = undefined
    lastSubmitId = undefined
    lastSubmitTime = undefined
    for submit in submits
        if submit.outcome == "DR"
            continue
        lastSubmitId = submit._id
        lastSubmitTime = submit.time
        if (submit.outcome in ["IG", "OK", "AC"]) and (not (points?))
            points = problem.points - 7 * attempts
            if points < 0
                points = 0
        if submit.outcome == "IG"
            if solved == 0
                ignored = 1
                ok = 0
            continue
        # any other result resets ignored flag
        ignored = 0
        if submit.outcome == "DQ"
            ignored = Result.DQconst
            solved = -2
            ok = 0
            break
        else if submit.outcome == "AC"
            solved = 1
            ok = 0
            continue  # we might have a future OK
        else if submit.outcome == "OK"
            ok = 1
            continue  # we might have a future AC
        else if submit.outcome != "CE" and submit.firstFail != 1 and (not (points?))
            attempts++
    points = points || 0
    if solved > 0
        points += problem.points
    result =         
        user: userId,
        table: problemId,
        total: 1,
        required: 1,
        solved: solved,
        ok: ok,
        attempts: attempts,
        ignored: ignored,
        points: points
        lastSubmitId: lastSubmitId,
        lastSubmitTime: lastSubmitTime

    logger.debug "updated result ", result
    result = new Result(result)
    await result.upsert()
    return result

export default updateResults = (user, dirtyResults) ->
    logger.info "updating results for user ", user
    await updateResultsForTable(user, Table.main, dirtyResults)
    logger.info "updated results for user ", user
