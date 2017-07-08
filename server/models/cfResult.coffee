mongoose = require('mongoose')

cfResultsSchema = new mongoose.Schema
    _id: String,
    userId: String,
    contestId: String,
    time: Date,
    place: Number,
    oldRating: Number,
    newRating: Number
    
    
cfResultsSchema.methods.upsert = ->
    @_id = @contestId + "::" + @userId
    @update(this, {upsert: true})
    
    
cfResultsSchema.statics.findLastResults = (limit) ->
    CfResult.find({}).sort({ time: -1, place: 1 }).limit(limit)

    
cfResultsSchema.index
    time: -1
    place: 1
        

CfResult = mongoose.model('CfResults', cfResultsSchema);

export default CfResult
