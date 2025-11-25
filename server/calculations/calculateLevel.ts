// @ts-ignore
import GROUPS from '../../client/lib/groups'
// @ts-ignore
import isContestRequired from '../../client/lib/isContestRequired'
import requiredProblemsByLevelMinor from '../../client/lib/requiredProblemsByLevelMinor'
import {parseLevel, encodeLevel, compareLevels} from '../../client/lib/level'
// @ts-ignore
import logger from '../log'

// @ts-ignore
import Table from '../models/table'
// @ts-ignore
import Result from '../models/result'

async function isFloatsSolved(userId: number, lastDate: Date, lang: String) {
    const result = await Result.findByUserAndTable(userId, "floats" + lang)
    if (!result)
        return false
    const submitDate = new Date(result.lastSubmitTime)
    if (submitDate >= lastDate)
        return false
    return result.solved == result.total
}

export default async function calculateLevel(user, lastDate: Date) {
    let userId = user._id
    let baseLevelId = user.level.base
    let lang = GROUPS[user.userList].lang
    const start = +(new Date())
    logger.info("calculate level ", userId, "baseLevel=", baseLevelId)
    if (!baseLevelId && (await isFloatsSolved(userId, lastDate, lang))) {
        baseLevelId = "1В"
        logger.info("calculate level ", userId, "baseLevel=>", baseLevelId, lastDate)
    }
    let baseLevel = parseLevel(baseLevelId)
    for (let major = 1; major <= 13; major++) {
        for (let minor = 1; minor <= 4; minor++) {
            const level = {major, minor}
            const levelId = encodeLevel({major, minor}, lang)
            const table = await Table.findById(levelId)
            if (!table)
                continue
            let probNumber = 0
            let probAc = 0
            let probDq = 0
            for (let subTableId of table.tables) {
                let subTable = await Table.findById(subTableId)
                if (!subTable)
                    continue
                for (let prob of subTable.problems) {
                    if (isContestRequired(subTable.name))
                        probNumber++
                    let result = await Result.findByUserAndTable(userId, prob)
                    if (!result)
                        continue
                    if (result.solved == 0)
                        continue
                    let submitDate = new Date(result.lastSubmitTime)
                    if (submitDate >= lastDate)
                        continue
                    probAc += result.solved
                    if (result.solved < 0)
                        probDq += 1
                }
            }
            let needProblem = requiredProblemsByLevelMinor(minor, probNumber)
            if (probAc < needProblem && probAc + 3 * probDq != probNumber && ((!baseLevel) || (compareLevels(baseLevel, level) <= 0))) {
                logger.info("calculated level", userId, levelId, " spent time ", +(new Date()) - start)
                return levelId
            }
        }
    }
    logger.info("calculated level", userId, " -> inf spent time ", +(new Date()) - start)
    return "100A"
}
