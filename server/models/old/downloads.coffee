DownloadsCollection = new Mongo.Collection 'downloads'

Downloads =
    findAll: ->
        @collection.find {}

    lastDownloadTime: (id) ->
        doc = @collection.findOne _id: "last" + id
        if !doc
            return new Date(0)
        doc.time
        
    setLastDownloadTime: (id, time) ->
        cid = "last" + id
        @collection.update({_id: cid}, {$set: {_id: cid, time: time}}, {upsert: true})

    isInProgress: ->
        doc = @collection.findOne _id: "inProgress"
        doc && doc.value
        
    setInProgress: (value) ->
        cid = "inProgress"
        @collection.update({_id: cid}, {$set: {_id: cid, value: value}}, {upsert: true})
        
    collection: DownloadsCollection
            
@Downloads = Downloads

