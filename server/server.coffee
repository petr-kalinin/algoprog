require('source-map-support').install()

import csshook from 'css-modules-require-hook/preset'

express = require('express')
passport = require('passport')
compression = require('compression')
responseTime = require('response-time')
StatsD = require('node-statsd')

import logger from './log'
import renderOnServer from './ssr/renderOnServer'
import db from './mongo/mongo'
import configurePassport from './passport'
import setupApi from './api/setupApi'

#import jobs from './cron/cron'

process.on 'unhandledRejection', (r) ->
    logger.error "Unhandled rejection "
    logger.error r

requireHTTPS = (req, res, next) ->
    if !req.secure and !req.headers.host.startsWith("127.0.0.1")  # the latter is to avoid inner api requests
        return res.redirect 'https://' + req.headers.host + req.url
    next()

stats = new StatsD()
stats.socket.on 'error',  (error) ->
    logger.error(error)

app = express()
app.enable('trust proxy')

if process.env["ENABLE_METRICS"]
    app.use(responseTime((req, res, time) ->
        stat = (req.method + req.url).toLowerCase()
            .replace(/[:.]/g, '')
            .replace(/\//g, '_')
        stats.timing(stat, time)
    ))

if process.env["FORCE_HTTPS"]
    app.use(requireHTTPS)

app.use(compression())

configurePassport(app, db)
setupApi(app)

app.use(express.static('build/assets'))

app.use(express.static('public'))

app.get '/status', (req, res) ->
    logger.info "Query string", req.query
    res.send "OK"

app.use renderOnServer

port = (process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000)
app.listen port, () ->
  logger.info 'App listening on port ', port

#import downloadMaterials from './cron/downloadMaterials'
#downloadMaterials()

#import * as downloadSubmits from "./cron/downloadSubmits"
#downloadSubmits.runLast()

import * as downloadContests from './cron/downloadContests'
try
    downloadContests.run()
catch e
    console.log e
