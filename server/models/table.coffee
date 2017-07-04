mongoose = require('mongoose')

tablesSchema = new mongoose.Schema
    _id: String
    name: String
    tables: [String]
    problems: [String]
    parent: String
    order: Number
        
tablesSchema.methods.upsert = () ->
    Table.update({_id: @_id}, this, {upsert: true}).exec()
    
tablesSchema.methods.height = () ->
        if @tables.length > 0
            return await (await Table.findById(@tables[0])).height() + 1
        else
            return 1
        
tablesSchema.methods.expand = () ->
        expandedTables = []
        for table in @tables
            subTable = await Table.findById(table)
            subTable.expand()
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
            result = result.concat(subTable.descendandTables())
        for problem in @problems
            result.push(problem)
            
            
tablesSchema.statics.removeDuplicateChildren = () ->
        tables = @findAll().fetch()
        for table in tables
            wasTables = {}
            newTables = []
            for subTable in table.tables
                if not (subTable of wasTables)
                    wasTables[subTable] = 1
                    newTables.push(subTable)
            table.tables = newTables
            Table.update({_id: table._id}, table)

tablesSchema.statics.main = "main"


Table = mongoose.model('Tables', tablesSchema);

export default Table
