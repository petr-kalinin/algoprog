import logger from '../log'

import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'
import TableResults from '../models/TableResults'
import {allTables} from '../materials/data/tables'

import addTotal from '../../client/lib/addTotal'
import awaitAll from '../../client/lib/awaitAll'

export getTables = (table) ->
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

needUser = (userId, tables) ->
    for tableId in tables
        result = await Result.findByUserAndTable(userId, tableId)
        if result and (result.solved > 0 or result.ok > 0 or result.attempts > 0 or result.ps > 0)
            return true
    return false

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

export getUserResult = (userId, tables, depth) ->
    if not await needUser(userId, tables)
        return null
    total = undefined
    results = []
    for tableId in tables
        tableResults = await recurseResults(userId, tableId, depth)
        if not tableResults
            continue
        total = addTotal(total, tableResults.total)
        delete tableResults.total
        results.push tableResults
    return
        results: results
        total: total

export default updateTableResults = (userId) ->
    start = new Date()
    logger.info "updating table results for user ", userId
    for table in allTables
        tables = await getTables(table)
        tableResults = await getUserResult(userId, tables, 1)
        if tableResults
            sumTable = new TableResults
                _id: "#{userId}::#{table}"
                user: userId
                table: table
                data: tableResults
            await sumTable.upsert()
        else
            await TableResults.remove
                user: userId
                table: table

    logger.info "updated table results for user ", userId, " spent time ", (new Date()) - start
