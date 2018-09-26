mongoose = require('mongoose')

import logger from '../log'

submitCommentsSchema = new mongoose.Schema
    _id: String
    problemId: String
    problemName: String
    userId: String
    text: String
    time: Date
    outcome: String
    viewed: { type: Boolean, default: false }

submitCommentsSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a submitComment"

submitCommentsSchema.statics.findLastNotViewedByUser = (id) ->
    SubmitComment.find({userId: id, viewed: false, time: {$gt: new Date(2017, 10, 11)}}) \
        .sort({time: -1}).limit(20)

submitCommentsSchema.statics.findLastByProblem = (id) ->
    SubmitComment.find({problemId: id}).sort({time: -1}).limit(20)

submitCommentsSchema.index
    userId: 1
    time: -1

submitCommentsSchema.index
    problemId: 1
    time: -1


SubmitComment = mongoose.model('shadSubmitComments', submitCommentsSchema);

export default SubmitComment
