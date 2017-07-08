import Submit from '../models/submit'
import Problem from '../models/problem'

startDayForWeeks = 
    "lic40": "2016-12-28"
    "zaoch": "2017-01-01"

WEEK_ACTIVITY_EXP = 0.55
LEVEL_RATING_EXP = 2.5
ACTIVITY_THRESHOLD = 0.1
MSEC_IN_WEEK = 7 * 24 * 60 * 60 * 1000

levelVersion = (level) ->
    if (level.slice(0,3) == "reg")
        major = 3
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
    thisStart = new Date(startDayForWeeks[user.userList])
    submits = await Submit.findByUser(user._id)
    probSolved = {}
    weekSolved = {}
    weekOk = {}
    wasSubmits = {}
    rating = 0
    activity = 0
    for s in submits
        if probSolved[s.problem]
            continue
        level = await findProblemLevel(s.problem)
        if not level
            continue
        submitDate = new Date(s.time)
        week = Math.floor((submitDate - thisStart) / MSEC_IN_WEEK)
        wasSubmits[week] = true
        if s.outcome == "AC"
            probSolved[s.problem] = true
            if !weekSolved[week]
                weekSolved[week] = 0
            weekSolved[week]++
            rating += levelScore(level)
            activity += activityScore(level, submitDate)
        else if s.outcome == "OK"
            if !weekOk[week]
                weekOk[week] = 0
            weekOk[week]++
    for level in ["1А", "1Б"]
        if (!user.baseLevel) or (level >= user.baseLevel)
            break
        for prob in await Problem.findByLevel(level)
            if probSolved[prob._id]
                continue
            rating += levelScore(level)
    for week of wasSubmits
        if !weekSolved[week]
            weekSolved[week] = 0.5
    for w of weekSolved
        if w<0
            delete weekSolved[w]
    for w of weekOk
        if w<0
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
