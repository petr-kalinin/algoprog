import Problem from '../models/problem'
import Result from '../models/result'
import Submit from '../models/submit'
import User from '../models/user'

import logger from '../log'

import getContestSystem from '../contestSystems/ContestSystemRegistry'

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
            await submit.remove()
        else
            seenSubmits.push(submit)

makeResultFromSubmitsList = (submits, userId, problemId, findMistake) ->
    solved = 0
    ps = 0
    attempts = 0
    lastSubmitId = undefined
    lastSubmitTime = undefined
    for submit in submits
        if submit.outcome == "DR" or submit.outcome == "PW" or submit.outcome == "DP"
            continue
        lastSubmitId = submit._id
        lastSubmitTime = submit.time
        if submit.outcome in ["AC", "OK"]
            solved = 1
        else if submit.outcome == "PS" or submit.outcome == "CT"
            ps = 1
        else if submit.outcome != "CE" and solved == 0
            attempts++
    problem = await Problem.findById(problemId)
    for contest in problem.contests
        contestSystem = getContestSystem(contest.contestSystem)
        contestResult = await contestSystem.makeProblemResult(submits)
        logger.debug "updated result ", userId, problemId, contest._id
        result = new Result
            user: userId,
            table: problemId,
            contest: contest._id
            ps: ps,
            attempts: attempts,
            lastSubmitId: lastSubmitId,
            lastSubmitTime: lastSubmitTime
            contestResult: contestResult
        await result.upsert()

updateResultsForProblem = (userId, problemId) ->
    await removeDuplicateSubmits(userId, problemId)
    submits = await Submit.findByUserAndProblem(userId, problemId)
    await makeResultFromSubmitsList(submits, userId, problemId)

export default updateResults = (user, problems) ->
    start = new Date()
    logger.info "updating results for user ", user
    if not problems
        problems = await Problem.findAll()
    for problem in problems
        await updateResultsForProblem(user, problem)
    logger.info "updated results for user ", user, " spent time ", (new Date()) - start
