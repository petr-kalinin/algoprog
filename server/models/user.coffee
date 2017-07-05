mongoose = require('mongoose')

import calculateChocos from '../calculations/calculateChocos'
import calculateRatingEtc from '../calculations/calculateRatingEtc'
import calculateLevel from '../calculations/calculateLevel'
import calculateCfRating from '../calculations/calculateCfRating'

SEMESTER_START = "2016-06-01"

usersSchema = new mongoose.Schema
    _id: String,
    name: String,
    userList: String,
    chocos: [Number],
    level:
        currrent: String,
        start: String,
        base: String,
    active: Boolean,
    ratingSort: Number,
    byWeek: [{solved: Number, ok: Number}],
    rating: Number,
    activity: Number,
    cf:
        login: Number,
        rating: Number,
        color: Number,
        activity: Number,
        progress: Number
        
usersSchema.methods.upsert = () ->
    User.update({_id: @_id}, this, {upsert: true}).exec()
    
usersSchema.methods.updateChocos = ->
    @chocos = await calculateChocos @_id
    console.log "calculated chocos", @name, @chocos
    User.update({_id: @_id}, {$set: {chocos: @chocos}})
        
usersSchema.methods.updateRatingEtc = ->
    res = await calculateRatingEtc this
    console.log "updateRatingEtc", @name, res
    User.update({_id: @_id}, {$set: res})
    
usersSchema.methods.updateLevel = ->
    @level = calculateLevel @_id, @baseLevel, new Date("2100-01-01")
    @startLevel = calculateLevel @_id, @baseLevel, new Date(SEMESTER_START)
    User.update({_id: @_id}, {$set: {level: @level, startLevel : @startLevel}})
    
usersSchema.methods.updateCfRating = ->
    res = calculateCfRating this
    if not res
        return
    @cfRating = res.rating
    @cfColor = res.color
    @cfActivity = res.activity
    @cfProgress = res.progress
    User.update({_id: @_id}, {$set: {cfRating: @cfRating, cfColor: @cfColor, cfActivity: @cfActivity, cfProgress: @cfProgress}})

usersSchema.methods.setBaseLevel = (level) ->
    User.update({_id: @_id}, {$set: {baseLevel: level}})
    @baseLevel = level
    @updateLevel()
    @updateRatingEtc()

usersSchema.methods.setCfLogin = (cfLogin) ->
    User.update({_id: @_id}, {$set: {cfLogin: cfLogin}})
    @cfLogin = cfLogin
    @updateCfRating()
    

usersSchema.statics.findByList = (list) ->
    User.find {userList: list}, {sort: {active: -1, level: -1, ratingSort: -1}}



usersSchema.index
    userList: 1
    active: -1
    level: -1
    ratingSort: -1

User = mongoose.model('Users', usersSchema);

export default User
