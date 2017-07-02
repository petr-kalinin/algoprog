require("babel-polyfill")
express = require('express')
bodyParser = require('body-parser')
MongoClient = require('mongodb').MongoClient
ObjectId = require('mongodb').ObjectID

#require('./cron/test-async-c')

import jobs from './cron/cron'

app = express()

app.use(express.static('build/client'))

app.get '/status', (req, res) -> 
  console.log "Query string", req.query
  res.send "OK"

app.listen 3000, () ->
  console.log 'Example app listening on port 3000!'
