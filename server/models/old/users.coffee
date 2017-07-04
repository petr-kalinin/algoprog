UsersCollection = new Mongo.Collection 'tableUsers'

# fields
#   _id
#   name
#   userList
#   chocos
#   level
#   startlevel
#   baselevel
#   active
#   ratingSort
#   solvedByWeek
#   okByWeek
#   rating
#   activity
#   cfLogin
#   cfRating
#   cfColor
#   cfActivity
#   cfProgress

@startDayForWeeks = 
    "lic40": "2016-12-28"
    "zaoch": "2017-01-01"
@MSEC_IN_WEEK = 7 * 24 * 60 * 60 * 1000
@SEMESTER_START = "2016-06-01"

UsersCollection.helpers
    updateChocos: ->
        @chocos = calculateChocos @_id
        console.log @name, @chocos
        Users.collection.update({_id: @_id}, {$set: {chocos: @chocos}})
        
    updateRatingEtc: ->
        res = calculateRatingEtc this
        console.log @name, res
        Users.collection.update({_id: @_id}, {$set: res})
        
    updateLevel: ->
        @level = calculateLevel @_id, @baseLevel, new Date("2100-01-01")
        @startLevel = calculateLevel @_id, @baseLevel, new Date(SEMESTER_START)
        Users.collection.update({_id: @_id}, {$set: {level: @level, startLevel : @startLevel}})
        
    updateCfRating: ->
        res = updateCfRating this
        if not res
            return
        @cfRating = res.rating
        @cfColor = res.color
        @cfActivity = res.activity
        @cfProgress = res.progress
        Users.collection.update({_id: @_id}, {$set: {cfRating: @cfRating, cfColor: @cfColor, cfActivity: @cfActivity, cfProgress: @cfProgress}})

    setBaseLevel: (level) ->
        Users.collection.update({_id: @_id}, {$set: {baseLevel: level}})
        @baseLevel = level
        if Meteor.isServer
            @updateLevel()
            @updateRatingEtc()

    setCfLogin: (cfLogin) ->
        Users.collection.update({_id: @_id}, {$set: {cfLogin: cfLogin}})
        @cfLogin = cfLogin
        if Meteor.isServer
            @updateCfRating()

Users =
    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find {}, {sort: {active: 1, level: -1, ratingSort: -1}}
        
    findByList: (list) ->
        @collection.find {userList: list}, {sort: {active: -1, level: -1, ratingSort: -1}}
        
    addUser: (id, name, userList) ->
        @collection.update({_id: id}, {$set: {_id: id, name: name, userList: userList}}, {upsert: true})
            
    collection: UsersCollection

@Users = Users

if Meteor.isServer
    Meteor.startup ->
        Users.collection._ensureIndex
            userList: 1
            active: -1
            level: -1
            ratingSort: -1
