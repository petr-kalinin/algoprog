mongoose = require('mongoose')

import Table from './table'
import logger from '../log'

problemsSchema = new mongoose.Schema
    _id: String
    name: String
    tables: [String]
    level: String
    testSystemData: mongoose.Schema.Types.Mixed
    order: String

problemsSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a problemsSchema"

problemsSchema.methods.add = () ->
    oldProblem = await Problem.findById @_id
    if oldProblem
        return
    @save()

problemsSchema.methods.addTable = (table) ->
    logger.debug "add table", @name, @tables
    if table in @tables
        return
    @tables.push(table)
    await @update({$set: { tables: @tables }})
    (await Problem.findById(@_id)).updateLevel()

problemsSchema.methods.updateLevel = ->
    reg = ""
    @level = ""
    for table in @tables
        level = (await Table.findById(table)).parent
        if (level.slice(0,3) == "reg") and (reg < level)
            reg = level
        else if (level.slice(0,3) == "roi") and (reg < level)
            reg = level
        else if level > @level
            @level = level
    if @level == ""
        @level = reg
    if @level == ""
        @level = undefined
    @update({$set: {level: @level}})        

problemsSchema.statics.findByLevel = (level) ->
    return Problem.find
        level: level

Problem = mongoose.model('Problems', problemsSchema);

export default Problem
