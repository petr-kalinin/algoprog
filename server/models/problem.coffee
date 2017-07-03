mongoose = require('mongoose')

problemsSchema = new mongoose.Schema
    _id: String
    letter: String
    name: String
    tables: [String]
    level: String
        
problemsSchema.methods.add = () ->
    oldProblem = await Problem.findById @_id
    if oldProblem
        return
    @save()

Problem = mongoose.model('Problems', problemsSchema);

export default Problem
