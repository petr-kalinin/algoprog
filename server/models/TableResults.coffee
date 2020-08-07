mongoose = require('mongoose')

import logger from '../log'

TableResultsSchema = new mongoose.Schema
    _id: String
    user: String
    table: String
    data: mongoose.Schema.Types.Mixed

TableResultsSchema.methods.upsert = () ->
    @update(this, {upsert: true, overwrite: true})

TableResultsSchema.statics.findByUserAndTable = (user, table) ->
    TableResults.findOne({user, table})

TableResultsSchema.index
    user: 1
    table: 1

TableResults = mongoose.model('TableResults', TableResultsSchema)

export default TableResults
