import csshook from 'css-modules-require-hook/preset'

express = require('express')
passport = require('passport')
connectEnsureLogin = require('connect-ensure-login')

import logger from './log'
import renderOnServer from './ssr/renderOnServer'

#import jobs from './cron/cron'

import db from './mongo/mongo'
import User from './models/user'
import Result from './models/result'
import Problem from './models/problem'
import Table from './models/table'
import RegisteredUser from './models/registeredUser'

import configurePassport from './passport'

require('source-map-support').install()

process.on 'unhandledRejection', (r) -> 
    logger.error "Unhandled rejection "
    logger.error r


app = express()

configurePassport(app)

app.use(express.static('build/assets'))

app.get '/status', (req, res) -> 
    logger.info "Query string", req.query
    res.send "OK"
    
app.post('/login', passport.authenticate('local', 
    successRedirect: '/api/me',
    failureRedirect: '/login'
))

app.post '/register', (req, res) ->
    user = new RegisteredUser
        username: req.body.username
        admin: false
    RegisteredUser.register user, req.body.password, (err) ->
        if (err)
            console.log 'error while user register!', err
            return next err
        console.log 'user registered!'
        res.redirect '/'
        
app.get('/api/me', connectEnsureLogin.ensureLoggedIn(), (req, res) ->
    res.json req.user
)

  
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
ip = (process.env.OPENSHIFT_NODEJS_IP || '0.0.0.0')
app.listen port, ip, () ->
  logger.info 'Example app listening on port ', port
