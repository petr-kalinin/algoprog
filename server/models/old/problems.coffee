ProblemsCollection = new Mongo.Collection 'problems'

# fields
#   _id
#   letter
#   name
#   tables[]
#   level

ProblemsCollection.helpers
    addTable: (table) ->
        console.log @name, @tables
        if table in @tables
            return
        console.log @_id, @tables, table
        @tables.push(table)
        console.log @_id, @tables, table
        Problems.collection.update({ _id: @_id }, {$set: { tables: @tables }})
        Problems.findById(@_id).updateLevel()
        
    updateLevel: ->
        reg = ""
        @level = ""
        for table in @tables
            console.log table
            level = Tables.findById(table).parent
            if (level.slice(0,3) == "reg") and (reg < level)
                reg = level
            else if level > @level
                @level = level
        if @level == ""
            @level = reg
        if @level == ""
            @level = undefined
        console.log @_id, @name, @level
        Problems.collection.update({_id: @_id}, {$set: {level: @level}})

    
Problems =
    findById: (id) ->
        @collection.findOne _id: id
        
    findByTable: (table) ->
        @collection.find tables: table

    findByLevel: (level) ->
        @collection.find level: level

    findAll: ->
        @collection.find {}
        
    addProblem: (id, letter, name) ->
        console.log @findById id
        if @findById id
            return
        @collection.insert({_id: id, letter: letter, name: name, tables: []})
        
    collection: ProblemsCollection
            
@Problems = Problems

#Meteor.startup ->
#    Problems.findById("p89").updateLevel()
#    for prob in Problems.findAll().fetch()
#        prob.updateLevel()
