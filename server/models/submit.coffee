mongoose = require('mongoose')

outcomeType = (outcome) ->
    switch outcome
        when "DR" then "DR"
        when "PS" then "PS"
        else "_"

submitsSchema = new mongoose.Schema
    _id: String
    time: Date
    downloadTime: { type: Date, default: new Date(0) }
    user: String
    problem: String
    outcome: String
    source: String
    sourceRaw: String
    language: String
    comments: [mongoose.Schema.Types.Mixed]
    results: mongoose.Schema.Types.Mixed
    force: { type: Boolean, default: false },
    quality: { type: Number, default: 0 },

submitsSchema.methods.upsert = () ->
    @update(this, {upsert: true, overwrite: true})

submitsSchema.methods.equivalent = (other) ->
    if @comments.length > 0
        return false
    if @outcome == "AC" or @outcome == "IG" or @outcome == "DQ"
        return false
    if @force
        return false
    return @user == other.user \
        and @problem == other.problem \
        and outcomeType(@outcome) == outcomeType(other.outcome) \
        and @source == other.source \
        and @sourceRaw == other.sourceRaw \
        and @language == other.language

submitsSchema.statics.findByUser = (userId) ->
    Submit.find
        user: userId

submitsSchema.statics.findByUserAndProblem = (userId, problemId) ->
    Submit.find({
        user: userId
        problem: problemId
    }).sort({time: 1})

submitsSchema.statics.findBestByProblem = (problemId, limit) ->
    Submit.find({
        problem: problemId,
        quality: {$gt: 0}
    })
        .sort({quality: -1, time: -1})
        .select({results: 0, comments: 0, force: 0})
        .limit(limit)

submitsSchema.statics.findLastNotCT = () ->
    for submit in await Submit.find({outcome: {$ne: "CT"}}).sort({time: -1}).limit(1)
        return submit

submitsSchema.statics.findPendingSubmits = (userId) ->
    Submit.find
        outcome: "PS"
        
submitsSchema.statics.findCT = (userId) ->
    Submit.find
        outcome: "CT"
        

submitsSchema.index({ user : 1, problem: 1, time: 1 })
submitsSchema.index({ user : 1, problem: 1, outcome: 1 })
submitsSchema.index({ outcome : 1, time : 1 })
submitsSchema.index({ time : 1 })
submitsSchema.index({ problem: 1, quality : -1, time: -1 })

Submit = mongoose.model('Submits', submitsSchema);

export default Submit
