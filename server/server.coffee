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

app = express()
app.use(compression())

configurePassport(app, db)
setupApi(app)

app.use(express.static('build/assets'))

app.use(express.static('public'))

app.get '/status', (req, res) ->
    logger.info "Query string", req.query
    res.send "OK"

app.post('/login', passport.authenticate('local',
    successRedirect: '/api/me',
    failureRedirect: '/login'
))

app.use renderOnServer

port = (process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000)
app.listen port, () ->
  logger.info 'App listening on port ', port

#import {updateAllResults} from './calculations/updateResults'
#updateAllResults()

#import downloadMaterials from './cron/downloadMaterials'
#downloadMaterials()
