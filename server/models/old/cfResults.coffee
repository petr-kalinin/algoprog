cfResultsCollection = new Mongo.Collection 'cfResults'

# fields
#   _id
#   userId
#   contestId
#   time
#   place
#   oldRating
#   newRating

@cfResults =

    addResult: (userId, contestId, time, place, oldRating, newRating) ->
        id = contestId + "::" + userId
        @collection.update({_id: id}, {$set: {_id: id, userId: userId, contestId: contestId, time: time, place: place, oldRating: oldRating, newRating: newRating}}, {upsert: true})
        
    findLastResults: (limit) ->
        @collection.find {}, {
            sort: { time: -1, place: 1 },
            limit: limit
        }
    
        
    collection: cfResultsCollection
    
if Meteor.isServer
    Meteor.startup ->
        cfResults.collection._ensureIndex
            time: -1
            place: 1
