connectEnsureLogin = require('connect-ensure-login')

import User from '../models/user'
import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'
import CfResult from '../models/cfResult'

expandResult = (result) ->
    res = result.toObject()
    res.user = (await User.findById(result.user)).toObject()
    res.table = (await Problem.findById(result.table)).toObject()
    tableNamePromises = []
    for table in res.table.tables
        tableNamePromises.push(Table.findById(table))
    tableNames = (await Promise.all(tableNamePromises)).map((table) -> table.name)
    res.table.tables = tableNames
    return res
    
expandResults = (results) ->
    promises = []
    for result in results
        promises.push(expandResult(result))
    res = await Promise.all(promises)
    return res
    
runDashboardQuery = (key, query, result) ->
    limit = 20
    if key == "ok"
        limit = 200
    subResults = await Result.find(query).sort({lastSubmitTime: -1}).limit(limit)
    result[key] = await expandResults(subResults)

expandCfResult = (result) ->
    result = result.toObject()
    result.user = (await User.findById(result.userId)).toObject()
    return result

runCfQuery = (result) ->
    cfr = await CfResult.findLastResults(20)
    result["cf"] = []
    for r in cfr
        result["cf"].push(expandCfResult(r))
    result["cf"] = await Promise.all(result["cf"])
    
export default dashboard = () ->
    queries = 
        ok: {ok: 1, lastSubmitTime: {$gt: new Date(2017, 8, 13)}},
        wa: {solved: 0, ok: 0, ignored: 0, attempts: {$gt: 0}},
        ig: {ignored: 1},
        ac: {solved: 1}
    result = {}
    promises = []
    for key, query of queries
        query["total"] = 1                          
        promises.push(runDashboardQuery(key, query, result))
    promises.push(runCfQuery(result))
    await Promise.all(promises)
    return result

