mongoose = require('mongoose')

submitsSchema = new mongoose.Schema
    _id: String,
    time: Date,
    user: String,
    problem: String,
    outcome: String
        
submitsSchema.methods.upsert = () ->
    console.log("Add submit", this)
    Submit.update({_id: @_id}, this, {upsert: true}).exec()

submitsSchema.index({ user : 1, problem: 1, time: 1 })
submitsSchema.index({ user : 1, problem: 1, outcome: 1 })
submitsSchema.index({ outcome : 1, time : 1 })
submitsSchema.index({ time : 1 })
        
Submit = mongoose.model('Submits', submitsSchema);

export default Submit
