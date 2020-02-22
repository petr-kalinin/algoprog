import User from '../models/user'
import Hash from '../models/Hash'
import Table from '../models/table'
import Result from '../models/result'
import Submit from '../models/submit'

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

removeDuplicateSubmits = (userId, problemId) ->
    submits = await Submit.findByUserAndProblem(userId, problemId)
    seenSubmits = []
    for submit in submits
        seen = false
        for seenSubmit in seenSubmits
            if submit.equivalent(seenSubmit)
                logger.info "Submit #{submit._id} is equivalent to submit #{seenSubmit._id}, will remove"
                seen = true
                break
        if seen
            await Hash.removeForSubmit(submit._id)
            await submit.remove()
        else
            seenSubmits.push(submit)

updateResultsForProblem = (userId, problemId, dirtyResults) ->
    if dirtyResults and (not ((userId + "::" + problemId) of dirtyResults))
        result = await Result.findByUserAndTable(userId, problemId)
        if result
            return result
    await removeDuplicateSubmits(userId, problemId)
    submits = await Submit.findByUserAndProblem(userId, problemId)
    solved = 0
    ok = 0
    ps = 0
    attempts = 0
    ignored = 0
    lastSubmitId = undefined
    lastSubmitTime = undefined
    for submit in submits
        if submit.outcome == "DR"
            continue
        lastSubmitId = submit._id
        lastSubmitTime = submit.time
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
        else if submit.outcome == "PS" or submit.outcome == "CT"
            ps = 1
        else if submit.outcome != "CE" and submit.outcome != "SV" and (not (points?))
            attempts++
    logger.debug "updated result ", userId, problemId, solved, ok, ps, attempts, ignored, lastSubmitId
    result = new Result
        user: userId,
        table: problemId,
        total: 1,
        required: 1,
        solved: solved,
        ok: ok,
        ps: ps,
        attempts: attempts,
        ignored: ignored,
        lastSubmitId: lastSubmitId,
        lastSubmitTime: lastSubmitTime
    await result.upsert()
    return result

export default updateResults = (user, dirtyResults) ->
    logger.info "updating results for user ", user
    await updateResultsForTable(user, Table.main, dirtyResults)
    logger.info "updated results for user ", user
