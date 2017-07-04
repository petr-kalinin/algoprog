require("babel-polyfill")
express = require('express')
bodyParser = require('body-parser')
MongoClient = require('mongodb').MongoClient
ObjectId = require('mongodb').ObjectID
mongoose = require('mongoose');

process.on 'unhandledRejection', (r) -> console.log(r)

import jobs from './cron/cron'

mongoose.Promise = global.Promise;
initMongo = ->
    await mongoose.connect 'mongodb://localhost/algoprog'

initMongo().catch (error)-> 
    console.log error
    process.exit(1)

db = mongoose.connection

app = express()

app.use(express.static('build/client'))

app.get '/status', (req, res) -> 
  console.log "Query string", req.query
  res.send "OK"

app.listen 3000, () ->
  console.log 'Example app listening on port 3000!'
