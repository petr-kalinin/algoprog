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

app = express()

app.use(express.static('build/assets'))

app.get '/status', (req, res) -> 
    logger.info "Query string", req.query
    res.send "OK"
  
app.get '/api/user/:id', (req, res) ->
    User.findOne({_id: req.params.id}, (err, record) ->
        res.json(record)
    )

app.use renderOnServer

app.listen 3000, () ->
  logger.info 'Example app listening on port 3000!'
