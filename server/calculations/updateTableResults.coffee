import logger from '../log'

import Material from '../models/Material'
import Problem from '../models/problem'
import Result from '../models/result'
import Table from '../models/table'
import TableResults from '../models/TableResults'
import User from '../models/user'

import {allTables} from '../materials/data/tables'

import addTotal from '../../client/lib/addTotal'
import awaitAll from '../../client/lib/awaitAll'
import GROUPS from '../../client/lib/groups'

export getTables = (table) ->
    if table == "main" or table == "nnoi"
        return [table]
    tableIds = table.split(",")
    if tableIds.length != 1
        return tableIds
    table = await Table.findById(tableIds[0])
    return table.tables

getTableName = (tableId) ->
    table = await Table.findById(tableId)
    table.name

getProblemName = (problemId, lang) ->
    material = await Material.findById(problemId + lang)
    material.title

getResult = (userId, tableId, tableNamePromise) ->
    result = await Result.findByUserAndTable(userId, tableId)
    result = result?.toObject() || {}
    result.problemName = await tableNamePromise
    return result

needUser = (userId, tables) ->
    for tableId in tables
        result = await Result.findByUserAndTable(userId, tableId)
        if result and (result.solved > 0 or result.ok > 0 or result.attempts > 0 or result.ps > 0)
            return true
    return false

recurseResults = (userId, lang, tableId, depth) ->
    table = await Table.findById(tableId)
    if not table
        return null
    tableResults = []
    total = undefined
    if depth > 0
        for subtableId in table.tables
            subtableResults = await recurseResults(userId, lang, subtableId, depth-1)
            total = addTotal(total, subtableResults.total)
            delete subtableResults.total
            tableResults.push(subtableResults)
    else
        for subtableId in table.tables
            namePromise = getTableName(subtableId)
            tableResults.push(getResult(userId, subtableId, namePromise))
        for subtableId in table.problems
            namePromise = getProblemName(subtableId, lang)
            tableResults.push(getResult(userId, subtableId, namePromise))
        tableResults = await awaitAll(tableResults)
        for r in tableResults
            total = addTotal(total, r)
    return
        _id: tableId,
        name: table.name
        results: tableResults
        total: total

correctLang = (table, lang) ->
    if lang == ""
        return table
    return table.replace("А", "A").replace("Б", "B").replace("В", "C").replace("Г", "D") + lang

export getUserResult = (userId, tables, depth) ->
    user = await User.findById(userId)
    lang = GROUPS[user.userList]?.lang
    tables = (correctLang(t, lang) for t in tables)
    if not await needUser(userId, tables)
        return null
    total = undefined
    results = []
    for tableId in tables
        tableResults = await recurseResults(userId, lang, tableId, depth)
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
    for table in ["0", "1", "main", "reg", "roi"]
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
