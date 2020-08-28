mongoose = require('mongoose')
import logger from '../log'


APPROVED = 2
DISPROVED = 1
UNKNOWN = 0

findMistakeSchema = new mongoose.Schema
    _id: String
    source: String
    submit: String
    correctSubmit: String
    user: {type: String, select: false}
    problem: String
    language: String
    approved: { type: Number, default: UNKNOWN },
    order: String

findMistakeSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a findMistake"

findMistakeSchema.methods.setApprove = (approve) ->
    logger.info "Approve findMistake #{@_id} -> #{approve}"
    @approved = if approve then APPROVED else DISPROVED
    @update(this)

findMistakeSchema.statics.findApprovedByProblemAndNotUser = (problem, user) ->
    FindMistake.find
        problem: problem
        user: {$ne: user}

findMistakeSchema.statics.findApprovedByNotUser = (user) ->
    FindMistake.find({
        approved: APPROVED
        user: {$ne: user}
    }).sort({order: 1})

findMistakeSchema.statics.findOneNotApproved = () ->
    FindMistake.findOne
        approved: UNKNOWN

findMistakeSchema.index({ problem : 1, user: 1, order: 1 })
findMistakeSchema.index({ approved : 1 })

FindMistake = mongoose.model('FindMistake', findMistakeSchema);

export default FindMistake
