import awaitAll from '../../client/lib/awaitAll'

import Contest from '../models/Contest'
import ContestResult from '../models/ContestResult'
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

makeResultFromSubmitsList = (submits, userId, problemId, contestForVirtual) ->
    solved = 0
    ps = 0
    attempts = 0
    lastSubmitId = undefined
    lastSubmitTime = undefined
    virtualId = undefined
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
        if submit.virtualId and virtualId and virtualId != submit.virtualId
            logger.warn("Different virtualId in updateResults: #{virtualId} and #{submit.virtualId}")
        virtualId = submit.virtualId
    problem = await Problem.findById(problemId)
    for contest in problem.contests
        if contestForVirtual and contestForVirtual._id != contest._id
            continue
        oldResult = await ContestResult.findByContestAndUser(contest._id, userId)
        contestSystem = getContestSystem(contest.contestSystem)
        contestResult = await contestSystem.makeProblemResult(submits, oldResult)
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
            virtualId: virtualId
        if contestForVirtual
            return result  # do not save
        await result.upsert()

updateResultsForContest = (contestId, userId, problemResultsForVirtual) ->
    oldResult = await ContestResult.findByContestAndUser(contestId, userId)
    contest = await Contest.findById(contestId)
    if not contest
        return
    if not problemResultsForVirtual
        problemResults = []
        for problem in contest.problems
            problemResults.push Result.findByUserTableAndContest(userId, problem._id, contest._id)
        problemResults = await awaitAll(problemResults)
    else 
        problemResults = problemResultsForVirtual
    contestSystem = getContestSystem(contest.contestSystemData.system)
    cr = await contestSystem.makeContestResult(problemResults)
    pr = {}
    vitualId = undefined
    for result in problemResults
        if result
            pr[result.table] = {
                _id: result._id
                table: result.table
                ps: result.ps
                attempts: result.attempts
                lastSubmitId: result.lastSubmitId
                lastSubmitTime: result.lastSubmitTime
                contestResult: result.contestResult 
            }
            if result.virtualId and virtualId and virtualId != result.virtualId
                logger.warn("Different virtualId in updateResults: #{virtualId} and #{result.virtualId}")
            virtualId = result.virtualId
    if oldResult?.virtualId and virtualId and virtualId != oldResult.virtualId
        logger.warn("Different virtualId in updateResults: #{virtualId} and #{oldResult.virtualId}")
    contestResult = new ContestResult
        user: userId
        contest: contest._id
        contestResult: cr
        problemResults: pr
        virtualId: virtualId
        virtualName: oldResult?.virtualName
        startTime: oldResult?.startTime
        registered: oldResult?.registered
    if problemResultsForVirtual
        return contestResult  # do not save
    await contestResult.upsert()

updateResultsForProblem = (userId, problemId) ->
    await removeDuplicateSubmits(userId, problemId)
    submits = await Submit.findByUserAndProblem(userId, problemId)
    await makeResultFromSubmitsList(submits, userId, problemId)
    
export makeVirtualResults = (userId, contestId, virtualTime) ->
    start = new Date()
    contest = await Contest.findById(contestId)
    contestResult = await ContestResult.findByContestAndUser(contestId, userId)
    lastTime = new Date(+contestResult.startTime + virtualTime)
    logger.info "making virtual results for user ", userId, lastTime
    problemResults = []
    for problemId in contest.problems
        submits = await Submit.findByUserAndProblemBeforeTime(userId, problemId, lastTime)
        problemResult = await makeResultFromSubmitsList(submits, userId, problemId, contest)
        problemResults.push(problemResult)
    contestResult = await updateResultsForContest(contestId, userId, problemResults)
    logger.info "made results for user ", userId, " spent time ", (new Date()) - start
    return contestResult

export default updateResults = (user, problems) ->
    start = new Date()
    logger.info "updating results for user ", user
    if not problems
        problems = await Problem.findAll()
    else
        problems = problems.map((p) -> Problem.findById(p))
        problems = await awaitAll problems
    contests = {}
    for problem in problems
        await updateResultsForProblem(user, problem)
        for c in problem.contests
            contests[c._id] = 1
    for c of contests
        await updateResultsForContest(c, user)
    logger.info "updated results for user ", user, " spent time ", (new Date()) - start
