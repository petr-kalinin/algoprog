process.on 'unhandledRejection', (r) -> 
    console.log "Unhandled rejection "
    console.log(r)

require("babel-polyfill")
express = require('express')
bodyParser = require('body-parser')

import jobs from './cron/cron'

import db from './mongo/mongo'

app = express()

app.use(express.static('build/client'))

app.get '/status', (req, res) -> 
  console.log "Query string", req.query
  res.send "OK"

app.listen 3000, () ->
  console.log 'Example app listening on port 3000!'
