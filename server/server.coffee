require('source-map-support').install()

import csshook from 'css-modules-require-hook/preset'

express = require('express')
fs = require('fs')
passport = require('passport')
path = require('path')
compression = require('compression')
responseTime = require('response-time')
StatsD = require('node-statsd')

import setupApi from './api/setupApi'
import scheduleJobs from './cron/cron'
import download from './lib/download'
import sleep from './lib/sleep'
import downloadMaterials from './materials/downloadMaterials'
import sendToGraphite from './metrics/graphite'
import setupMetrics from './metrics/metrics'
import notify from './metrics/notify'
import db from './mongo/mongo'
import Submit from './models/submit'
import Result from './models/result'
import User from './models/user'
import renderOnServer from './ssr/renderOnServer'
import {REGISTRY} from './testSystems/TestSystemRegistry'

import logger from './log'
import configurePassport from './passport'


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
expressWs = require('express-ws')(app)
app.enable('trust proxy')

setupMetrics(app)

if process.env["FORCE_HTTPS"]
    app.use(requireHTTPS)

app.use(compression())

configurePassport(app, db)

if process.env["TECH_WORKS"]
    app.use (req, res, next) ->
        if not req.user?.admin
            res.status(503).send("На сервере проводятся технические работы. Ожидаемая продолжительность — несколько часов.")
            return
        next()

setupApi(app)

app.use(express.static('build/server'))
app.use(express.static('build/assets'))

app.use(express.static('public'))

app.get '/status', (req, res) ->
    logger.info "Query string", req.query
    res.send "OK"

linkClientJsCss = JSON.parse(fs.readFileSync(path.resolve(__dirname, '../assets/manifest.json'), 'utf-8'))

app.use renderOnServer(linkClientJsCss)

port = (process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000)

start = () ->
    await downloadMaterials()

    app.listen port, () ->
        notify "Started"
        logger.info 'App listening on port ', port
        sendToGraphite {}
        for id, system of REGISTRY
            system.selfTest()
        await sleep(30 * 1000)  # wait for a bit to make sure previous deployment has been stopped
        if not (process.env["INSTANCE_NUMBER"]?) or (process.env["INSTANCE_NUMBER"] == "0")
            logger.info("Starting jobs ", process.env["INSTANCE_NUMBER"])
            scheduleJobs()
        else
            logger.info("Will not start jobs", process.env["INSTANCE_NUMBER"])

start()
