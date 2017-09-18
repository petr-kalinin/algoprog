mongoose = require('mongoose')

import logger from '../log'

submitCommentsSchema = new mongoose.Schema
    _id: String
    problemId: String
    problemName: String
    userId: String
    text: String

submitCommentsSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a submitComment"

SubmitComment = mongoose.model('SubmitComments', submitCommentsSchema);

export default SubmitComment
