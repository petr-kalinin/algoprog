mongoose = require('mongoose')

import Table from './table'

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
    
problemsSchema.methods.addTable = (table) ->
    console.log "add table", @name, @tables
    if table in @tables
        return
    @tables.push(table)
    Problem.update({ _id: @_id }, {$set: { tables: @tables }})
    await (await Problem.findById(@_id)).updateLevel()
        
problemsSchema.methods.updateLevel = ->
    reg = ""
    @level = ""
    for table in @tables
        level = (await Table.findById(table)).parent
        if (level.slice(0,3) == "reg") and (reg < level)
            reg = level
        else if level > @level
            @level = level
    if @level == ""
        @level = reg
    if @level == ""
        @level = undefined
    Problem.update({_id: @_id}, {$set: {level: @level}})

Problem = mongoose.model('Problems', problemsSchema);

export default Problem
