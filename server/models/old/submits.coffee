SubmitsCollection = new Mongo.Collection 'submits'

# fields
#   _id
#   time
#   user
#   problem
#   outcome

Submits =
    findById: (id) ->
        @collection.findOne _id: id
        
    findAcByUserAndProblem: (user, problem) ->
        @collection.find({user: user, problem: problem, outcome: "AC"})

    findByUserAndProblem: (user, problem) ->
        @collection.find({user: user, problem: problem}, {sort: {time: 1}})
        
    findByUser: (user) ->
        @collection.find({user: user}, {sort: {time: 1}})
        
    findByOutcome: (outcome) ->
        @collection.find({outcome: outcome}, {sort: {time: 1}})
       
    findLastByOutcome: (outcome, limit) ->
        @collection.find({outcome: outcome}, {sort: {time: -1}, limit: limit})
       
    addSubmit: (id, time, user, problem, outcome) ->
        @collection.update({_id: id}, {_id: id, time: time, user: user, problem: problem, outcome: outcome}, {upsert: true})
        
    findAll: ->
        @collection.find {}
        
    collection: SubmitsCollection
            
@Submits = Submits

if Meteor.isServer
    Meteor.startup ->
        Submits.collection._ensureIndex({ user : 1, problem: 1, time: 1 });
        Submits.collection._ensureIndex({ user : 1, problem: 1, outcome: 1 });
        Submits.collection._ensureIndex({ outcome : 1, time : 1 });
        Submits.collection._ensureIndex({ time : 1 });