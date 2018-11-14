mongoose = require('mongoose')

submitsSchema = new mongoose.Schema
    _id: String
    time: Date
    user: String
    problem: String
    outcome: String
    source: String
    sourceRaw: Buffer
    language: String
    comments: [String]
    results: mongoose.Schema.Types.Mixed
    firstFail: Number
    force: { type: Boolean, default: false },
    quality: { type: Number, default: 0 },
    bonus: { type: Number, default: 0 },

submitsSchema.methods.upsert = () ->
    @update(this, {upsert: true, overwrite: true})

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

submitsSchema.index({ user : 1, problem: 1, time: 1 })
submitsSchema.index({ user : 1, problem: 1, outcome: 1 })
submitsSchema.index({ outcome : 1, time : 1 })
submitsSchema.index({ time : 1 })
submitsSchema.index({ problem: 1, quality : -1, time: -1 })

Submit = mongoose.model('shadSubmits', submitsSchema);

export default Submit
