mongoose = require('mongoose')

import logger from '../log'

summaryTableSchema = new mongoose.Schema
    _id: String
    user: String
    tableName: String
    table: mongoose.Schema.Types.Mixed

summaryTableSchema.methods.upsert = () ->
    @update(this, {upsert: true, overwrite: true})

SummaryTable = mongoose.model('SummaryTable', summaryTableSchema)

export default SummaryTable
