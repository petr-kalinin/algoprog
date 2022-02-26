mongoose = require('mongoose')

import logger from '../log'

contestsSchema = new mongoose.Schema
    _id: String
    name: String
    problems: [{name: String, _id: String, letter: String}]
    contestSystemData: mongoose.Schema.Types.Mixed
    length: Number
    freeze: Number
    order: Number
    hasStatements: Boolean

contestsSchema.methods.upsert = () ->
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a problemsSchema"

contestsSchema.statics.findAll = () ->
    Contest.find {}

export default Contest = mongoose.model('Contests', contestsSchema);

