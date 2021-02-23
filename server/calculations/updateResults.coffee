import Result from '../models/result'
import Submit from '../models/submit'
import Problem from '../models/problem'
import User from '../models/user'

import logger from '../log'

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
            # await Hash.removeForSubmit(submit._id)
            await submit.remove()
        else
            seenSubmits.push(submit)

makeResultFromSubmitsList = (submits, userId, problemId, findMistake) ->
    # TODO: do we need it always?..
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
        ###
        total: 1,
        required: 1,
        solved: solved,
        ok: ok,
        ps: ps,
        ###
        attempts: attempts,
        # ignored: ignored,
        lastSubmitId: lastSubmitId,
        lastSubmitTime: lastSubmitTime
        # findMistake: findMistake

updateResultsForProblem = (userId, problemId) ->
    ###
    if dirtyResults and (not ((userId + "::" + problemId) of dirtyResults))
        result = await Result.findByUserAndTable(userId, problemId)
        if result
            return result
    ###
    await removeDuplicateSubmits(userId, problemId)
    submits = await Submit.findByUserAndProblem(userId, problemId)
    # fmResults = await updateResultsForFindMistake(userId, problemId)
    result = await makeProblemResult(userId, problemId, submits)
    # await processForFindMistake(submits)
    return result

###
updateResultsForFindMistake = (userId, problemId) ->
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
###

makeProblemResult = (userId, problemId, submits) ->
    result = makeResultFromSubmitsList(submits, userId, problemId)
    # result.subFindMistakes = await makeSubFindMistakes(problemId, fmResults) 
    await result.upsert()
    return result

###
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
###

export default updateResults = (user, problems) ->
    start = new Date()
    logger.info "updating results for user ", user
    if not problems
        problems = await Problem.findAll()
    for problem in problems
        await updateResultsForProblem(user, problem)
    logger.info "updated results for user ", user, " spent time ", (new Date()) - start
