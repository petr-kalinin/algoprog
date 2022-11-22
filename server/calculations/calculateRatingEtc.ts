// @ts-ignore
import GROUPS from '../../client/lib/groups'
import {Level, parseLevel, encodeLevel, compareLevels} from '../../client/lib/level'

// @ts-ignore
import Submit from '../models/submit'
// @ts-ignore
import Problem from '../models/problem'
// @ts-ignore
import Result from '../models/result'
// @ts-ignore
import logger from '../log'

// @ts-ignore
import {lastWeeksToShow, WEEK_ACTIVITY_EXP, LEVEL_RATING_EXP, ACTIVITY_THRESHOLD, MSEC_IN_WEEK, FM_CONST} from './ratingConstants'

const DEBUG_USER_ID = "------"

function correctRegLevel(level: Level): Level {
    if (level.major != null && level.major != undefined) {
        return level
    } if (level.regMajor == "sch") {
        return {major: 1, minor: 3}
    } else if (level.regMajor == "nnoi") {
        return {major: 2, minor: 2}
    } else if (level.regMajor == "reg") {
        return {major: 3, minor: 1}
    } else if (level.regMajor == "roi") {
        return {major: 6, minor: 1}
    }
    throw new Error("Can't correct level " + level)
}

function levelScore(level: Level): number {
    const correctedLevel = correctRegLevel(level)
    let res = Math.pow(LEVEL_RATING_EXP, (correctedLevel.major + 1))
    res *= Math.pow(LEVEL_RATING_EXP, 0.25 * (correctedLevel.minor - 1))
    logger.debug(`level ${encodeLevel(level)} res=${res}`)
    return res
}

async function findProblemLevel(problemId: String): Promise<Level> {
    const problem = await Problem.findById(problemId)
    return parseLevel(problem?.level)
}

function timeScore(date: Date): number {
    const weeks = (+(new Date()) - (+date))/MSEC_IN_WEEK
    return Math.pow(WEEK_ACTIVITY_EXP, weeks)
}

function activityScore(level: Level, date: Date) {
    const v = correctRegLevel(level)
    return Math.sqrt(v.major + 1) * timeScore(date)
}

export default async function calculateRatingEtc(user) {
    const start = new Date()
    logger.info("calculate rating etc ", user._id)
    const thisStart = new Date(GROUPS[user.userList].startDayForWeeks)
    const lang = GROUPS[user.userList].lang
    const now = new Date()
    const nowWeek = Math.floor((+now - (+thisStart)) / MSEC_IN_WEEK)
    const firstWeek = nowWeek - lastWeeksToShow + 1

    function weekByTime(time: number) {
        const submitDate = new Date(time)
        return Math.floor((+submitDate - (+thisStart)) / MSEC_IN_WEEK)
    }
    function inc(dict, key, add=1) {
        if (!(key in dict)) {
            dict[key] = 0
        }
        dict[key] += add
    }

    const submits = await Submit.findByUser(user._id)
    const results = await Result.findByUser(user._id)
    const fmResults = await Result.findByUserWithFindMistakeSet(user._id)
    const weekSolved = {}
    const weekOk = {}
    const wasSubmits = {}
    let rating = 0
    let activity = 0
    const probSolved = {}

    for (const s of submits) {
        if (s.outcome == "DR")
            continue
        const level = await findProblemLevel(s.problem)
        if (!level)
            continue
        wasSubmits[weekByTime(s.time)] = true
    }

    for (const r of results) {
        const level = await findProblemLevel(r.table)
        if (!level)  // this will happen, in particular, if this is not a problem result
            continue
        const week = weekByTime(r.lastSubmitTime)
        if (r.solved == 1) {
            inc(weekSolved, week)
            rating += levelScore(level)
            if (user._id == DEBUG_USER_ID)
                console.log("add rating 1 ", r.table, encodeLevel(level), levelScore(level), rating)
            activity += activityScore(level, r.lastSubmitTime)
            probSolved[r.table] = true
        } else if (r.solved < 0) { // DQ
            inc(weekSolved, week, -2)
            rating -= 2 * levelScore(level)
            activity -= 2 * activityScore(level, r.lastSubmitTime)
        } else if (r.ok == 1) {
            inc(weekOk, week)
        }
    }
    for (const r of fmResults) {
        const level = await findProblemLevel(r.table)
        if (!level)  // this will happen, in particular, if this is not a problem result
            continue
        const week = weekByTime(r.lastSubmitTime)
        if (r.solved == 1 || r.ok == 1) {
            rating += levelScore(level) * FM_CONST
            if (user._id == DEBUG_USER_ID)
                console.log("add rating 2 ", r.table, encodeLevel(level), levelScore(level), rating)
            activity += activityScore(level, r.lastSubmitTime) * FM_CONST
        }
    }
    const floatsResult = await Result.findByUserAndTable(user._id, "floats" + lang)
    let base: Level = parseLevel(user.level.base)
    const isFloatsSolved = floatsResult && (floatsResult.solved == floatsResult.total)
    if (isFloatsSolved) {
        base = {major: 1, minor: 3}
    }
    for (const minor of [1, 2]) {
        const level: Level = {major: 1, minor: minor}
        if ((!base) || (compareLevels(level, base) >= 0)) {
            break
        }
        // This is not quite correct, because we take problems from RU level even for other langs.
        // But probSolved has keys without lang.
        /*
        for (const prob of await Problem.findByLevel(encodeLevel(level))) {
            if (probSolved[prob._id]) {
                continue
            }
            rating += levelScore(level)
            if (user._id == DEBUG_USER_ID)
                console.log("add rating 3 ", prob._id, encodeLevel(level), levelScore(level), rating)
        }
        */
    }

    for (const week in wasSubmits) {
        if (!weekSolved[week])
            weekSolved[week] = 0.5
    }

    for (const w in weekSolved) {
        if (+w<+firstWeek)
            delete weekSolved[w]
    }
    for (const w in weekOk) {
        if (+w<firstWeek)
            delete weekOk[w]
    }

    if (user._id == DEBUG_USER_ID)
        console.log("activity=", activity, "rating=", rating)

    activity *= (1 - WEEK_ACTIVITY_EXP)
    logger.info("calculated rating etc ", user._id, " spent time ", +(new Date()) - +start, "activity=", activity, "rating=", rating)
    return {
        byWeek: {
            solved: weekSolved,
            ok: weekOk
        },
        rating: Math.floor(rating),
        activity: activity,
        ratingSort: (activity > ACTIVITY_THRESHOLD) ? rating : (-1/(rating+1)),
        active: (activity > ACTIVITY_THRESHOLD) ? 1 : 0
    }
}