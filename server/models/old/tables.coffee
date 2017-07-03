TablesCollection = new Mongo.Collection 'tables'

# fields
#   _id
#   name
#   tables[]
#   problems[]
#   parent
#   order

TablesCollection.helpers
    addTable: (id) ->
        Tables.collection.update({ _id: @_id }, {$push: { tables: id }})
        Tables.cache = {}
        
    height: ->
        if @tables.length > 0
            return Tables.findById(@tables[0]).height() + 1
        else
            return 1
        
    expand: ->
        expandedTables = []
        for table in @tables
            subTable = Tables.findById(table)
            subTable.expand()
            expandedTables.push(subTable)
        @tables = expandedTables
        expandedProblems = []
        for problem in @problems
            expandedProblem = Problems.findById(problem)
            expandedProblems.push(expandedProblem)
        @problems = expandedProblems
        return this
        
    descendandTables: ->
        result = [@_id]
        for table in @table
            subTable = Tables.findById(table)
            result = result.concat(subTable.descendandTables())
        for problem in @problems
            result.push(problem)
        
parentFromParent = (level) ->
    if level == Tables.main
        return undefined
    p = parseLevel(level)
    if p.minor
        return p.major
    else 
        return Tables.main
        
Tables =
    main: "main"

    findById: (id) ->
        if not (id of @cache)
            console.log "tables cache miss"
            @cache[id] = @collection.findOne({_id: id})
        if not @cache[id]
            return @cache[id]
        copy = JSON.parse(JSON.stringify(@cache[id]))
        return @collection._transform(copy)
        
    findAll: ->
        @collection.find({}, {sort: {_id: 1}})
        
    addTable: (id, name, tables, problems, parent, order) ->
        @collection.update({_id: id}, 
                           {_id: id, name: name, tables: tables, problems: problems, parent: parent, order: order}, 
                           {upsert: true})
        @cache = {}
        for prob in problems
            console.log prob, id
            Problems.findById(prob).addTable(id)
        if parent
            if not @findById(parent)
                pp = parentFromParent(parent)
                Tables.addTable(parent, parent, [], [], pp, order-1)
            Tables.findById(parent).addTable(id)
            
    removeDuplicateChildren: ->
        tables = @findAll().fetch()
        for table in tables
            wasTables = {}
            newTables = []
            for subTable in table.tables
                if not (subTable of wasTables)
                    wasTables[subTable] = 1
                    newTables.push(subTable)
            table.tables = newTables
            @collection.update({_id: table._id}, table)
            @cache = {}
        
    collection: TablesCollection
    
    cache: {}
            
@Tables = Tables
