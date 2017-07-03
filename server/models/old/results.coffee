ResultsCollection = new Mongo.Collection 'results'

# fields
#   _id
#   user
#   userList
#   table
#   total
#   solved
#   ok 
#   attempts
#   lastSubmitId
#   lastSubmitTime
#   ignored   // for problems only

MAX_CACHE_SIZE = 100000

Results =
    DQconst: -10
    
    addToCache: (id, data) ->
        if @cacheSize >= MAX_CACHE_SIZE
            @cacheSize = 0
            @cache = {}
        @cacheSize++
        @cache[id] = data

    addResult: (user, table, total, solved, ok, attempts, ignored, lastSubmitId, lastSubmitTime) ->
        userList = Users.findById(user).userList
        id = user + "::" + table
        data = {_id: id, user: user, userList: userList, table: table, total: total, solved: solved, ok: ok, attempts: attempts, ignored: ignored, lastSubmitId: lastSubmitId, lastSubmitTime: lastSubmitTime}
        @collection.update({_id: id}, 
                           data, 
                           {upsert: true})
        @addToCache(id, data)

    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find {}
    
    findByUserListAndTable: (userList, table) ->
        tableList = Tables.findById(table).descendandTables()
        @collection.find {
            userList: userList, 
            table: {$in: tableList}
        }, sort: { solved: -1, attempts: 1}
            
    findByUserList: (userList) ->
        @collection.find {
            userList: userList
        }, sort: { solved: -1, attempts: 1}
            
    findByUser: (userId) ->
        @collection.find {
            user: userId, 
        }

    findByUserAndTable: (userId, tableId) ->
        key = userId + "::" + tableId
        if not (key of @cache)
            @addToCache(key, @collection.findOne {
                _id: userId + "::" + tableId
            })
        return @cache[key]
    
    findLastWA: (limit) ->
        @collection.find {
            total: 1,  # this is a problem, not a contest
            solved: 0,
            ok: 0,
            ignored: 0,
            attempts: {$gte: 1},
        }, {
            sort: { lastSubmitTime: -1 },
            limit: limit
        }
        
    
    collection: ResultsCollection
    
    cache: {}
    
    cacheSize: 0
            
@Results = Results

if Meteor.isServer
    Meteor.startup ->
        Results.collection._ensureIndex
            userList: 1
            table : 1 
            solved: -1
            attempts: 1

        Results.collection._ensureIndex
            userList: 1
            solved: -1
            attempts: 1

        Results.collection._ensureIndex
            user: 1
            table: 1

        Results.collection._ensureIndex
            total: 1
            solved: 1 
            ok: 1
            ignored: 1
            attempts: 1
            lastSubmitTime: -1
