import logger from './log'

require('source-map-support').install()

process.on 'unhandledRejection', (r) -> 
    logger.error "Unhandled rejection "
    logger.error r

require("babel-polyfill")
express = require('express')
bodyParser = require('body-parser')

#import jobs from './cron/cron'

import db from './mongo/mongo'

app = express()

app.use(express.static('build/client'))

app.get '/status', (req, res) -> 
  logger.info "Query string", req.query
  res.send "OK"
  
app.get '/', (req, res) ->
    res.sendFile("./build/client/index.html")

app.listen 3000, () ->
  logger.info 'Example app listening on port 3000!'
