import Submit from '../models/submit'
import Problem from '../models/problem'
import Result from '../models/result'
import logger from '../log'

import {startDayForWeeks, lastWeeksToShow, WEEK_ACTIVITY_EXP, LEVEL_RATING_EXP, ACTIVITY_THRESHOLD, MSEC_IN_WEEK, FM_CONST} from './ratingConstants'

export levelVersion = (level) ->
    if (level.slice(0,3) == "reg")
        major = 3
        minor = 'А'
    else if (level.slice(0,3) == "roi")
        major = 6
        minor = 'А'
    else
        major = parseInt(level.slice(0, -1))
        minor = level[level.length - 1]
    return {
        major: major,
        minor: minor
    }

levelScore = (level) ->
    v = levelVersion(level)
    res = Math.pow(LEVEL_RATING_EXP, v.major)
    minorExp = Math.pow(LEVEL_RATING_EXP, 0.25)
    if v.minor >= 'Б'
        res *= minorExp
    if v.minor >= 'В'
        res *= minorExp
    if v.minor >= 'Г'
        res *= minorExp
    logger.debug "level #{level} res=#{res}"
    return res

findProblemLevel = (problemId) ->
    problem = await Problem.findById(problemId)
    problem?.level

timeScore = (date) ->
    weeks = (new Date() - date)/MSEC_IN_WEEK
    return Math.pow(WEEK_ACTIVITY_EXP, weeks)

activityScore = (level, date) ->
    v = levelVersion(level)
    return Math.sqrt(v.major) * timeScore(date)

export default calculateRatingEtc = (user) ->
    start = new Date()
    logger.info "calculate rating etc ", user._id
    thisStart = new Date(startDayForWeeks[user.userList])
    now = new Date()
    nowWeek = Math.floor((now - thisStart) / MSEC_IN_WEEK)
    firstWeek = nowWeek - lastWeeksToShow + 1

    weekByTime = (time) ->
        submitDate = new Date(time)
        return Math.floor((submitDate - thisStart) / MSEC_IN_WEEK)
    inc = (dict, key, add=1) ->
        if not (key of dict)
            dict[key] = 0
        dict[key] += add

    submits = await Submit.findByUser(user._id)
    results = await Result.findByUser(user._id)
    fmResults = await Result.findByUserWithFindMistakeSet(user._id)
    weekSolved = {}
    weekOk = {}
    wasSubmits = {}
    rating = 0
    activity = 0
    probSolved = {}

    for s in submits
        if s.outcome == "DR"
            continue
        level = await findProblemLevel(s.problem)
        if not level
            continue
        wasSubmits[weekByTime(s.time)] = true

    for r in results
        level = await findProblemLevel(r.table)
        if not level  # this will happen, in particular, if this is not a problem result
            continue
        week = weekByTime(r.lastSubmitTime)
        if r.solved == 1 
            inc(weekSolved, week)
            rating += levelScore(level)
            activity += activityScore(level, r.lastSubmitTime)
            probSolved[r.table] = true
        else if r.solved < 0  # DQ
            inc(weekSolved, week, -2)
            rating -= 2 * levelScore(level)
            activity -= 2 * activityScore(level, r.lastSubmitTime)
        else if r.ok == 1
            inc(weekOk, week)

    for r in fmResults
        level = await findProblemLevel(r.table)
        if not level  # this will happen, in particular, if this is not a problem result
            continue
        week = weekByTime(r.lastSubmitTime)
        if r.solved == 1 or r.ok == 1
            rating += levelScore(level) * FM_CONST
            activity += activityScore(level, r.lastSubmitTime) * FM_CONST

    for level in ["1А", "1Б"]
        if (!user.level.base) or (level >= user.level.base)
            break
        for prob in await Problem.findByLevel(level)
            if probSolved[prob._id]
                continue
            rating += levelScore(level)

    for week of wasSubmits
        if !weekSolved[week]
            weekSolved[week] = 0.5

    for w of weekSolved
        if w<firstWeek
            delete weekSolved[w]
    for w of weekOk
        if w<firstWeek
            delete weekOk[w]

    activity *= (1 - WEEK_ACTIVITY_EXP) # make this averaged
    return {
        byWeek: {
            solved: weekSolved,
            ok: weekOk
        },
        rating: Math.floor(rating),
        activity: activity,
        ratingSort: if activity > ACTIVITY_THRESHOLD then rating else -1/(rating+1),
        active: if activity > ACTIVITY_THRESHOLD then 1 else 0
    }
    logger.info "calculated rating etc ", user._id, " spent time ", (new Date()) - start
