import processForFindMistake from '../findMistake/processForFindMistake'

import FindMistake from '../models/FindMistake'
import Hash from '../models/Hash'
import Result from '../models/result'
import Submit from '../models/submit'
import Table from '../models/table'
import User from '../models/user'

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
    submits = await Submit.findByUserAndProblemWithFindMistakeAny(userId, problemId)
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

makeResultFromSubmitsList = (submits, userId, problemId, findMistake) ->
    solved = 0
    ok = 0
    ps = 0
    attempts = 0
    ignored = 0
    lastSubmitId = undefined
    lastSubmitTime = undefined
    for submit in submits
        if submit.outcome == "DR" or submit.outcome == "PW" or submit.outcome == "DP"
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
        else if submit.outcome != "CE" and solved == 0
            attempts++
    logger.debug "updated result ", userId, problemId, findMistake, solved, ok, ps, attempts, ignored, lastSubmitId
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
        findMistake: findMistake

updateResultsForProblem = (userId, problemId, dirtyResults) ->
    if dirtyResults and (not ((userId + "::" + problemId) of dirtyResults))
        result = await Result.findByUserAndTable(userId, problemId)
        if result
            return result
    await removeDuplicateSubmits(userId, problemId)
    submits = await Submit.findByUserAndProblem(userId, problemId)
    fmResults = await updateResultsForFindMistake(userId, problemId, dirtyResults)
    result = await makeProblemResult(userId, problemId, submits, fmResults)
    await processForFindMistake(submits)
    return result

updateResultsForFindMistake = (userId, problemId, dirtyResults) ->
    if dirtyResults and (not ((userId + "::" + problemId) of dirtyResults))
        return []
    submits = await Submit.findByUserAndProblemWithFindMistakeSet(userId, problemId)
    submitsByFindMistake = {}
    for submit in submits
        fm = submit.findMistake
        if not (fm of submitsByFindMistake)
            submitsByFindMistake[fm] = []
        submitsByFindMistake[fm].push(submit)
    allResults = []
    for fm, submits of submitsByFindMistake
        result = makeResultFromSubmitsList(submits, userId, problemId, fm)
        await result.upsert()
        allResults.push result
    return allResults

makeProblemResult = (userId, problemId, submits, fmResults) ->
    result = makeResultFromSubmitsList(submits, userId, problemId)
    result.subFindMistakes = await makeSubFindMistakes(problemId, fmResults) 
    await result.upsert()
    return result

makeSubFindMistakes = (problemId, results) ->
    result = 
        ok: 0
        wa: 0
        none: 0
    for r in results || []
        if r.ok > 0 or r.solved > 0
            result.ok++
        else if r.attempts > 0
            result.wa++
    totalFm = (await FindMistake.findApprovedByProblemAndNotUser(problemId, null)).length
    result.none = totalFm - result.ok - result.wa
    return result

export default updateResults = (user, dirtyResults) ->
    start = new Date()
    logger.info "updating results for user ", user
    await updateResultsForTable(user, "main", dirtyResults)
    logger.info "updated results for user ", user, " spent time ", (new Date()) - start
