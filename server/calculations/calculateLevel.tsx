// @ts-ignore
import GROUPS from '../../client/lib/groups'
// @ts-ignore
import isContestRequired from '../../client/lib/isContestRequired'
import {parseLevel, encodeLevel} from '../../client/lib/level'
// @ts-ignore
import logger from '../log'

// @ts-ignore
import Table from '../models/table'
// @ts-ignore
import Result from '../models/result'

async function isFloatsSolved(userId: number, lastDate: Date) {
    const result = await Result.findByUserAndTable(userId, "floats")
    if (!result)
        return false
    const submitDate = new Date(result.lastSubmitTime)
    if (submitDate >= lastDate)
        return false
    return result.solved == result.total
}

export default function calculateLevel(user, lastDate: Date) {
    let userId = user._id
    let baseLevelId = user.level.base
    const start = new Date()
    logger.info("calculate level ", userId, "baseLevel=", baseLevelId)
    if (!baseLevelId && (await isFloatsSolved(userId, lastDate))) {
        baseLevelId = "1В"
        logger.info("calculate level ", user, "baseLevel=>", baseLevelId, lastDate)
    }
    let baseLevel = parseLevel(baseLevelId)
    let lang = GROUPS[user.userList].lang
    for (let major = 1; major <= 13; major++) {
        for (let minor = 1; minor <= 4; minor++) {
            const levelId = encodeLevel({major, minor}, lang)
            const table = await Table.findById(levelId)
            if (!table)
                continue
            let probNumber = 0
            let probAc = 0
            for (let subTableId of table.tables) {
                let subTable = await Table.findById(subTableId)
                if (not subTable)
                    continue
                for prob in subTable.problems
                    if isContestRequired(subTable.name)
                        probNumber++
                    result = await Result.findByUserAndTable(user, prob)
                    if not result
                        continue
                    if result.solved == 0
                        continue
                    submitDate = new Date(result.lastSubmitTime)
                    if submitDate >= lastDate
                        continue
                    probAc += result.solved
            needProblem = probNumber
            if smallLevel == "В"
                needProblem = probNumber * 0.5
            else if smallLevel == "Г"
                needProblem = probNumber * 0.3333
            if (probAc < needProblem) and ((!baseLevel) or (baseLevel <= level))
                logger.info "calculated level", user, level, " spent time ", (new Date()) - start
                return level
        }
    }
    logger.info "calculated level", user, "inf spent time ", (new Date()) - start
    return "inf"
}