connectEnsureLogin = require('connect-ensure-login')

import User from '../models/user'
import Result from '../models/result'
import Submit from '../models/submit'
import Problem from '../models/problem'
import Table from '../models/table'
import CfResult from '../models/cfResult'

import awaitAll from '../../client/lib/awaitAll'

# note that months start from 0
export START_SUBMITS_DATE = new Date(2020, 2, 20)

expandResult = (result) ->
    res = result.toObject()
    res.fullUser = (await User.findById(result.user))
    if not res.fullUser
        return undefined
    res.fullUser = res.fullUser.toObject()
    res.fullTable = (await Problem.findById(result.table))?.toObject() || {}
    if res.lastSubmitId
        res.fullSubmit = (await Submit.findById(result.lastSubmitId))?.toObject() or {}
        delete res.fullSubmit.source
        delete res.fullSubmit.sourceRaw
        delete res.fullSubmit.results
    tableNamePromises = []
    if res.fullTable?.tables?
        for table in res.fullTable.tables
            tableNamePromises.push(Table.findById(table))
        tableNames = (await awaitAll(tableNamePromises)).map((table) -> table.name)
        res.fullTable.tables = tableNames
    return res

expandResults = (results) ->
    promises = []
    for result in results
        promises.push(expandResult(result))
    res = await awaitAll(promises)
    res = (r for r in res when r)
    return res

runDashboardQuery = (key, query, result) ->
    limit = 20
    if key == "ok" or key == "ps"
        limit = 200
    subResults = await Result.find(query).sort({lastSubmitTime: -1}).limit(limit)
    result[key] = await expandResults(subResults)

expandCfResult = (result) ->
    result = result.toObject()
    result.fullUser = await User.findById(result.userId)
    if not result.fullUser
        return undefined
    if not result.fullUser.cf
        return undefined
    result.fullUser = result.fullUser.toObject()
    return result

runCfQuery = (result) ->
    cfr = await CfResult.findLastResults(20)
    result["cf"] = []
    for r in cfr
        result["cf"].push(expandCfResult(r))
    result["cf"] = await awaitAll(result["cf"])
    result["cf"] = (r for r in result["cf"] when r)

export default dashboard = (registeredUser) ->
    userLists = registeredUser?.adminData?.defaultUserLists
    queries =
        # remember that months start from 0
        ok: {ok: 1, lastSubmitTime: {$gt: START_SUBMITS_DATE}},
        ps: {ps: 1},
        wa: {solved: 0, ok: 0, ignored: 0, attempts: {$gt: 0}},
        ig: {ignored: 1},
        ac: {solved: 1},
        fm_ok: {$or: [{ok: 1}, {solved: 1}], findMistake: {$ne: null}},
        fm_wa: {solved: 0, ok: 0, ignored: 0, attempts: {$gt: 0}, findMistake: {$ne: null}}
    result = {}
    promises = []
    for key, query of queries
        query.total = 1
        if key != "ps"
            query.findMistake = query.findMistake || null
            if userLists?.length
                query["userList"] = {$in: userLists}
            else
                query["userList"] = {$ne: "unknown"}
            query["activated"] = true
        promises.push(runDashboardQuery(key, query, result))
    promises.push(runCfQuery(result))
    await awaitAll(promises)
    return result
