require('source-map-support').install()

import csshook from 'css-modules-require-hook/preset'

express = require('express')
passport = require('passport')
compression = require('compression')

import logger from './log'
import renderOnServer from './ssr/renderOnServer'
import db from './mongo/mongo'
import configurePassport from './passport'
import setupApi from './api/setupApi'

import jobs from './cron/cron'

process.on 'unhandledRejection', (r) ->
    logger.error "Unhandled rejection "
    logger.error r

requireHTTPS = (req, res, next) ->
    logger.info "secure=", req.secure, req.protocol, req.headers.host, req.url, req.headers["X-Forwarded-Proto"]
    if !req.secure and req.headers.host != "127.0.0.1"  # the latter is to avoid inner api requests
        return res.redirect 'https://' + req.headers.host + req.url
    next()

app = express()
app.enable('trust proxy')

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

#import {updateAllResults} from './calculations/updateResults'
#updateAllResults()

#import downloadMaterials from './cron/downloadMaterials'
#downloadMaterials()
