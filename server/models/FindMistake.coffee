mongoose = require('mongoose')
import logger from '../log'


APPROVED = 2
DISPROVED = 1
UNKNOWN = 0
BAD = -1

PER_PAGE = 20


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

findMistakeSchema.methods.setBad = () ->
    logger.info "Bad findMistake #{@_id}"
    @approved = BAD
    @update(this)

findMistakeSchema.statics.findApprovedByProblemAndNotUser = (problem, user) ->
    FindMistake.find
        approved: APPROVED
        problem: problem
        user: {$ne: user}

findMistakeSchema.statics.findApprovedByNotUser = (user, page) ->
    FindMistake.find({
        approved: APPROVED
        user: {$ne: user}
    }).sort({order: 1}).skip(page * PER_PAGE).limit(PER_PAGE)

findMistakeSchema.statics.findApprovedByNotUserAndProblem = (user, problem, page) ->
    FindMistake.find({
        approved: APPROVED
        user: {$ne: user}
        problem
    }).sort({order: 1}).skip(page * PER_PAGE).limit(PER_PAGE)

findMistakeSchema.statics.findPagesCountForApprovedByNotUser = (user) ->
    return 
        pagesCount: Math.ceil(await FindMistake.find({approved: APPROVED, user: {$ne: user}}).countDocuments() / PER_PAGE)
        perPage: PER_PAGE

findMistakeSchema.statics.findPagesCountForApprovedByNotUserAndProblem = (user, problem) ->
    return 
        pagesCount: Math.ceil(await FindMistake.find({approved: APPROVED, user: {$ne: user}, problem}).countDocuments() / PER_PAGE)
        perPage: PER_PAGE

findMistakeSchema.statics.findOneNotApproved = () ->
    FindMistake.findOne
        approved: UNKNOWN

findMistakeSchema.statics.findNotApprovedCount = () ->
    FindMistake.find({approved: UNKNOWN}).countDocuments()

findMistakeSchema.index({ problem : 1, user: 1, order: 1 })
findMistakeSchema.index({ approved : 1 })

FindMistake = mongoose.model('FindMistake', findMistakeSchema);

export default FindMistake
