
import logger from '../log'

import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'
import SummaryTable from '../models/SummaryTable'

import addTotal from '../../client/lib/addTotal'
import awaitAll from '../../client/lib/awaitAll'

getTables = (table) ->
    if table == "main"
        return ["main"]
    tableIds = table.split(",")
    if tableIds.length != 1
        return tableIds
    table = await Table.findById(tableIds[0])
    return table.tables

getResult = (userId, tableId, collection) ->
    table = await collection.findById(tableId)
    result = await Result.findByUserAndTable(userId, tableId)
    result = result?.toObject() || {}
    result.problemName = table.name
    return result

recurseResults = (userId, tableId, depth) ->
    table = await Table.findById(tableId)
    if not table
        return null
    tableResults = []
    total = undefined
    if depth > 0
        for subtableId in table.tables
            subtableResults = await recurseResults(userId, subtableId, depth-1)
            total = addTotal(total, subtableResults.total)
            delete subtableResults.total
            tableResults.push(subtableResults)
    else
        for subtableId in table.tables
            tableResults.push(getResult(userId, subtableId , Table))
        for subtableId in table.problems
            tableResults.push(getResult(userId, subtableId , Problem))
        tableResults = await awaitAll(tableResults)
        for r in tableResults
            total = addTotal(total, r)
    return
        _id: tableId,
        name: table.name
        results: tableResults
        total: total


updateResultsForTable = (userId, tables) ->
    total = undefined
    results = []
    for tableId in tables
        tableResults = await recurseResults(userId, tableId, 1)
        if not tableResults
            continue
        total = addTotal(total, tableResults.total)
        delete tableResults.total
        results.push tableResults
    return
        results: results
        total: total

needUser = (userId, tables) ->
    for tableId in tables
        result = await Result.findByUserAndTable(userId, tableId)
        if result and (result.solved > 0 or result.ok > 0 or result.attempts > 0 or result.ps > 0)
            return true
    return false


export default updateResultTables = (userId) ->
    logger.info "updating summary tables for user ", userId
    allTables = ["1А,1Б", "1В,1Г", "2", "3", "4", "5", "6", "7", "8", "9", "10", "main", "reg", "roi"]
    for table in allTables
        tables = await getTables(table)
        if await needUser(userId, tables)
            tableResults = await updateResultsForTable(userId, tables)
            sumTable = new SummaryTable 
                _id: "#{userId}::#{table}"
                user: userId
                tableName: table
                table: tableResults
            await sumTable.upsert()
    logger.info "updated summary tables for user ", userId
