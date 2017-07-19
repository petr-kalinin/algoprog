import csshook from 'css-modules-require-hook/preset'

express = require('express')

import logger from './log'
import renderOnServer from './ssr/renderOnServer'

require('source-map-support').install()

process.on 'unhandledRejection', (r) -> 
    logger.error "Unhandled rejection "
    logger.error r

#import jobs from './cron/cron'

import db from './mongo/mongo'
import User from './models/user'
import Result from './models/result'
import Problem from './models/problem'
import Table from './models/table'

app = express()

app.use(express.static('build/assets'))

app.get '/status', (req, res) -> 
    logger.info "Query string", req.query
    res.send "OK"
  
app.get '/api/user/:id', (req, res) ->
    User.findOne({_id: req.params.id}, (err, record) ->
        res.json(record)
    )
    
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
    subResults = await Result.find(query).sort({lastSubmitTime: -1}).limit(20)
    result[key] = await expandResults(subResults)

app.get '/api/dashboard', (req, res) ->
    queries = 
        ok: {ok: 1, lastSubmitTime: {$gt: new Date(2017, 6, 10)}},
        wa: {solved: 0, ok: 0},
        ig: {ignored: 1},
        ac: {solved: 1}
    result = {}
    promises = []
    for key, query of queries
        query["total"] = 1
        promises.push(runDashboardQuery(key, query, result))
    await Promise.all(promises)
    res.json(result)

app.use renderOnServer

port = (process.env.OPENSHIFT_NODEJS_PORT || 3000)
app.listen port, () ->
  logger.info 'Example app listening on port ', port
