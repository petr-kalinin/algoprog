connectEnsureLogin = require('connect-ensure-login')

import User from '../models/user'
import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'
import RegisteredUser from '../models/registeredUser'

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


export default setupApi = (app) ->
    app.post '/api/register', (req, res, next) ->
        user = new RegisteredUser
            username: req.body.username
            admin: false
        RegisteredUser.register user, req.body.password, (err) ->
            if (err)
                return next err
            res.redirect '/'
            
    app.get('/api/me', connectEnsureLogin.ensureLoggedIn(), (req, res) ->
        res.json req.user
    )

    app.post '/api/user/:id/set', connectEnsureLogin.ensureLoggedIn(), (req, res) ->
        if not req.user?.admin
            res.status(403).send('No permissions')
        User.findOne({_id: req.params.id}, (err, record) ->
            await record.setBaseLevel req.body.level.base
            await record.setCfLogin req.body.cf.login
            res.send('OK')
        )
    
    app.get '/api/user/:id', (req, res) ->
        User.findOne({_id: req.params.id}, (err, record) ->
            res.json(record)
        )
        
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

