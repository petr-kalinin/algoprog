connectEnsureLogin = require('connect-ensure-login')

import logger from '../log'

import User from '../models/user'
import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'

import addTotal from '../../client/lib/addTotal'

getTables = (table) ->
    return [table]
    if table == "main"
        return ["main"]
    tableIds = table.split(",")
    if tableIds.length != 1
        return tableIds
    table = await Table.findById(tableIds[0])
    return table.tables

getResult = (userId, tableId, collection, late) ->
    table = await collection.findById(tableId)
    result = await Result.findByUserTableAndLate(userId, tableId, late)
    result = result.toObject()
    result.problemName = table.name
    return result

needUser = (userId, tables) ->
    for tableId in tables
        result = await Result.findByUserTableAndLate(userId, tableId, true)
        if result and (result.solved > 0 or result.ok > 0 or result.attempts > 0)
            return true
    return false

recurseResults = (user, tableId, depth) ->
    table = await Table.findById(tableId)
    tableResults = []
    tableResultsLate = []
    total = undefined
    if depth > 0
        for subtableId in table.tables
            subtableResults = await recurseResults(user, subtableId, depth-1)
            total = addTotal(total, subtableResults.total)
            delete subtableResults.total
            tableResults.push(subtableResults)
    else
        for subtableId in table.tables
            tableResults.push(getResult(user._id, subtableId, Table, false))
            tableResultsLate.push(getResult(user._id, subtableId, Table, true))
        for subtableId in table.problems
            tableResults.push(getResult(user._id, subtableId, Problem, false))
            tableResultsLate.push(getResult(user._id, subtableId, Problem, true))
        tableResults = await Promise.all(tableResults)
        tableResultsLate = await Promise.all(tableResultsLate)
        for r in tableResults
            total = addTotal(total, r)
    result = 
        _id: tableId,
        name: table.name
        results: tableResults
        total: total
    if depth == 0
        result.resultsLate = tableResultsLate
    return result

getUserResult = (user, tables, depth) ->
    if not await needUser(user._id, tables)
        return null
    total = undefined
    results = []
    for tableId in tables
        tableResults = await recurseResults(user, tableId, depth)
        total = addTotal(total, tableResults.total)
        delete tableResults.total
        results.push tableResults
    return {user, results, total}

sortBySolved = (a, b) ->
    if a.user.active != b.user.active
        return if a.user.active then -1 else 1
    if a.total.solved != b.total.solved
        return b.total.solved - a.total.solved
    if a.total.attempts != b.total.attempts
        return a.total.attempts - b.total.attempts
    return 0

sortByLevel = (a, b) ->
    if a.user.active != b.user.active
        return if a.user.active then -1 else 1
    if a.user.level.current != b.user.level.current
        return if a.user.level.current > b.user.level.current then -1 else 1
    if a.user.level != b.user.level
        return if a.user.level > b.user.level then -1 else 1
    return 0

sortByPoints = (a, b) ->
    if a.user.points != b.user.points
        return if a.user.points > b.user.points then -1 else 1
    return 0

export default table = (userList, table) ->
    data = []
    users = await User.findByList(userList)
    tables = await getTables(table)
    #[users, tables] = await Promise.all([users, tables])
    for user in users
        data.push(getUserResult(user, tables, 1))
    results = await Promise.all(data)
    results = (r for r in results when r)
    results = results.sort(sortByPoints)
    return results

export fullUser = (userId) ->
    tables = [["semester1"], ["semester2"]]
    user = await User.findById(userId)
    if not user
        return null
    results = []
    for t in tables
        results.push(getUserResult(user, t, 1))
    results = await Promise.all(results)
    results = (r.results for r in results when r)
    return
        user: user.toObject()
        results: results
