import Table from '../models/table'
import Result from '../models/result'
import logger from '../log'
import isContestRequired from '../../client/lib/isContestRequired'

isFloatsSolved = (user, lastDate) ->
    result = await Result.findByUserAndTable(user, "floats")
    if not result
        return false
    submitDate = new Date(result.lastSubmitTime)
    if submitDate >= lastDate
        return false
    return result.solved == result.total

export default calculateLevel = (user, baseLevel, lastDate) ->
    start = new Date()
    logger.info "calculate level ", user, "baseLevel=", baseLevel
    if (not baseLevel) and (await isFloatsSolved(user, lastDate))
        baseLevel = "1В"
        logger.info "calculate level ", user, "baseLevel=>", baseLevel, lastDate
    for bigLevel in [1..10]
        for smallLevel in ["А", "Б", "В", "Г"]
            tableId = bigLevel + smallLevel
            level = tableId
            table = await Table.findById(tableId)
            if not table
                continue
            probNumber = 0
            probAc = 0
            for subTableId in table.tables
                subTable = await Table.findById(subTableId)
                if not subTable
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
    logger.info "calculated level", user, "inf spent time ", (new Date()) - start
    return "inf"
