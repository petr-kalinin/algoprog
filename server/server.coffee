require('source-map-support').install()

import csshook from 'css-modules-require-hook/preset'

express = require('express')
passport = require('passport')

import logger from './log'
import renderOnServer from './ssr/renderOnServer'
import db from './mongo/mongo'
import configurePassport from './passport'
import setupApi from './api/setupApi'

#import jobs from './cron/cron'

process.on 'unhandledRejection', (r) -> 
    logger.error "Unhandled rejection "
    logger.error r

app = express()

configurePassport(app)
setupApi(app)

app.use(express.static('build/assets'))

app.get '/status', (req, res) -> 
    logger.info "Query string", req.query
    res.send "OK"
    
app.post('/login', passport.authenticate('local', 
    successRedirect: '/api/me',
    failureRedirect: '/login'
))

app.use renderOnServer

port = (process.env.OPENSHIFT_NODEJS_PORT || 3000)
ip = (process.env.OPENSHIFT_NODEJS_IP || '0.0.0.0')
app.listen port, ip, () ->
  logger.info 'Example app listening on port ', port
