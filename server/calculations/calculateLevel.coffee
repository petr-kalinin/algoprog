import Table from '../models/table'
import Result from '../models/result'
import logger from '../log'
import isContestRequired from '../../client/lib/isContestRequired'

export default calculateLevel = (user, baseLevel, lastDate) ->
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
                    result = await Result.findByUserTableAndLate(user, prob, true)
                    if not result
                        continue
                    if result.solved == 0
                        continue
                    submitDate = new Date(result.lastSubmitTime)
                    if submitDate >= lastDate
                        continue
                    probAc++
            needProblem = probNumber
            if smallLevel == "В"
                needProblem = probNumber * 0.5
            else if smallLevel == "Г"
                needProblem = probNumber * 0.3333
            if (probAc < needProblem) and ((!baseLevel) or (baseLevel <= level))
                logger.debug "calculated level", user, level
                return level
    return "inf"
