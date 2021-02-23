mongoose = require('mongoose')

import logger from '../log'

contestsSchema = new mongoose.Schema
    _id: String
    name: String
    problems: [{name: String, _id: String}]
    contestSystemData: mongoose.Schema.Types.Mixed
    order: Number

contestsSchema.methods.upsert = () ->
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a problemsSchema"

export default Contest = mongoose.model('Contests', contestsSchema);

