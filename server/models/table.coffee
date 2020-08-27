import parseLevel from '../lib/parseLevel'
import Problem from './problem'
import logger from '../log'

mongoose = require('mongoose')

tablesSchema = new mongoose.Schema
    _id: String
    name: String
    tables: [String]
    problems: [String]
    parent: String
    order: String


tablesSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a tablesSchema"

tablesSchema.methods.height = () ->
        if @tables.length > 0
            return await (await Table.findById(@tables[0])).height() + 1
        else
            return 1

tablesSchema.methods.expand = () ->
        expandedTables = []
        for table in @tables
            subTable = await Table.findById(table)
            await subTable.expand()
            expandedTables.push(subTable)
        @tables = expandedTables
        expandedProblems = []
        for problem in @problems
            expandedProblem = await Problem.findById(problem)
            expandedProblems.push(expandedProblem)
        @problems = expandedProblems
        return this

tablesSchema.methods.descendandTables = () ->
        result = [@_id]
        for table in @table
            subTable = await Table.findById(table)
            result = result.concat(await subTable.descendandTables())
        for problem in @problems
            result.push(problem)
        result


tablesSchema.statics.findAll = ->
    @find {}

Table = mongoose.model('Tables', tablesSchema);

export default Table
