mongoose = require('mongoose')

import logger from '../log'

submitProcessSchema = new mongoose.Schema
    _id: String
    attempts: Number
    lastAttempt: Date

submitProcessSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a submitProcess"


SubmitProcess = mongoose.model('SubmitProcess', submitProcessSchema);

export default SubmitProcess
