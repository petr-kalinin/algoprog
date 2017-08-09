connectEnsureLogin = require('connect-ensure-login')

import logger from '../log'

import User from '../models/user'
import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'

import addTotal from '../../client/lib/addTotal'

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
    result = result.toObject()
    result.problemName = table.name
    return result  

needUser = (userId, tables) ->
    for tableId in tables
        result = await Result.findByUserAndTable(userId, tableId)
        if result.solved > 0 or result.ok > 0 or result.attempts > 0
            return true
    return false

recurseResults = (user, tableId, depth) ->
    table = await Table.findById(tableId)
    tableResults = []
    total = null
    if depth > 0
        for subtableId in table.tables
            subtableResults = await recurseResults(user, subtableId, depth-1)
            total = addTotal(total, subtableResults.total)
            delete subtableResults.total
            tableResults.push(subtableResults)
    else
        for subtableId in table.tables
            tableResults.push(getResult(user._id, subtableId , Table))
        for subtableId in table.problems
            tableResults.push(getResult(user._id, subtableId , Problem))
        tableResults = await Promise.all(tableResults)
        for r in tableResults
            total = addTotal(total, r)
    return
        _id: tableId,
        name: table.name
        results: tableResults
        total: total

getUserResult = (user, tables, depth) ->
    if not await needUser(user._id, tables)
        return null
    total = null
    results = []
    for tableId in tables
        tableResults = await recurseResults(user, tableId, depth)
        total = addTotal(total, tableResults.total)
        delete tableResults.total
        results.push tableResults
    return 
        user: user
        results: results
        total: total
                
export default table = (userList, table) ->
    data = []
    users = User.findByList(userList)
    tables = getTables(table)
    [users, tables] = await Promise.all([users, tables])
    for user in users
        data.push(getUserResult(user, tables, 1))
    results = await Promise.all(data)
    results = (r for r in results when r)
    results = results.sort (a, b) ->
        if a.user.active != b.user.active
            return if a.user.active then -1 else 1
        if a.total.solved != b.total.solved
            return b.total.solved - a.total.solved 
        if a.total.attempts != b.total.attempts
            return a.total.attempts - b.total.attempts
        return 0
    return results
