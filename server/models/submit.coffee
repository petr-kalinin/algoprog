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

Submit = mongoose.model('Submits', submitsSchema);

export default Submit
