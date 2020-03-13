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
import {REGISTRY} from './testSystems/TestSystemRegistry'
import download from './lib/download'
import jobs from './cron/cron'
import sleep from './lib/sleep'
import setupMetrics from './metrics/metrics'
import sendToGraphite from './metrics/graphite'

import notify from './metrics/notify'

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

setupMetrics(app)

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

port = (process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 4000)


start = () ->
    try
        await logger.info("My ip is " + JSON.parse(await download 'https://api.ipify.org/?format=json')["ip"])
    catch
        logger.error("Can not determine my ip")

    app.listen port, () ->
        logger.info 'App listening on port ', port
        sendToGraphite {}
        for id, system of REGISTRY
            system.selfTest()
        await sleep(30 * 1000)  # wait for a bit to make sure previous deployment has been stopped
        if not (process.env["INSTANCE_NUMBER"]?) or (process.env["INSTANCE_NUMBER"] == "0")
            logger.info("Starting jobs ", process.env["INSTANCE_NUMBER"])
            jobs.map((job) -> job.start())
        else
            logger.info("Will not start jobs", process.env["INSTANCE_NUMBER"])

start()
