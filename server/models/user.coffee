mongoose = require('mongoose')

import calculateChocos from '../calculations/calculateChocos'
import calculateRatingEtc from '../calculations/calculateRatingEtc'
import calculateLevel from '../calculations/calculateLevel'
import calculateCfRating from '../calculations/calculateCfRating'

import logger from '../log'

import updateResults from '../calculations/updateResults'

import sleep from '../lib/sleep'

SEMESTER_START = "2016-06-01"

usersSchema = new mongoose.Schema
    _id: String,
    name: String,
    userList: String,
    chocos: [Number],
    level:
        current: String,
        start: String,
        base: String,
    active: Boolean,
    ratingSort: Number,
    byWeek: {solved: mongoose.Schema.Types.Mixed, ok: mongoose.Schema.Types.Mixed},
    rating: Number,
    activity: Number,
    cf:
        login: String,
        rating: Number,
        color: String,
        activity: Number,
        progress: Number
    paidTill: Date

usersSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a user"

usersSchema.methods.updateChocos = ->
    @chocos = await calculateChocos @_id
    logger.debug "calculated chocos", @name, @chocos
    @update({$set: {chocos: @chocos}})

usersSchema.methods.updateRatingEtc = ->
    res = await calculateRatingEtc this
    logger.debug "updateRatingEtc", @name, res
    @update({$set: res})

usersSchema.methods.updateLevel = ->
    @level.current = await calculateLevel @_id, @level.base, new Date("2100-01-01")
    @level.start = await calculateLevel @_id, @level.base, new Date(SEMESTER_START)
    @update({$set: {level: @level}})

usersSchema.methods.updateCfRating = ->
    logger.debug "Updating cf rating ", @name
    res = await calculateCfRating this
    logger.debug "Updated cf rating ", @name, res
    if not res
        return
    res.login = @cf.login
    @update({$set: {cf: res}})

usersSchema.methods.setBaseLevel = (level) ->
    await @update({$set: {"level.base": level}})
    @level.base = level
    await @updateLevel()
    @updateRatingEtc()

usersSchema.methods.setCfLogin = (cfLogin) ->
    logger.info "setting cf login ", @_id, cfLogin
    await @update({$set: {"cf.login": cfLogin}})
    @cf.login = cfLogin
    @updateCfRating()

usersSchema.methods.setPaidTill = (paidTill) ->
    logger.info "setting paidTill login ", @_id, paidTill
    await @update({$set: {"paidTill": paidTill}})
    @paidTill = paidTill

usersSchema.methods.setUserList = (userList) ->
    logger.info "setting userList ", @_id, userList
    await @update({$set: {"userList": userList}})
    @userList = userList


usersSchema.statics.findByList = (list) ->
    User.find({userList: list}).sort({active: -1, "level.current": -1, ratingSort: -1})

usersSchema.statics.findAll = (list) ->
    User.find {}

usersSchema.statics.updateUser = (userId, dirtyResults) ->
    logger.info "Updating user", userId
    await updateResults(userId, dirtyResults)
    u = await User.findById(userId)
    await u.updateChocos()
    await u.updateRatingEtc()
    await u.updateLevel()
    logger.info "Updated user", userId

usersSchema.statics.updateAllUsers = (dirtyResults) ->
    users = await User.find {}
    promises = []
    for u in users
        promises.push(User.updateUser(u._id))
        if promises.length > 30
            logger.info("Updating 30 users, waiting for completion")
            await Promise.all(promises)
            logger.info("Updated 30 users, continuing")
            promises = []
    await Promise.all(promises)
    logger.info("Updated all users")

usersSchema.statics.updateAllCf = () ->
    logger.info "Updating cf ratings"
    for u in await User.findAll()
        if u.cf.login
            await u.updateCfRating()
            await sleep(500)  # don't hit CF request limit
    logger.info "Updated cf ratings"


usersSchema.index
    userList: 1
    active: -1
    level: -1
    ratingSort: -1

usersSchema.index
    username: 1

User = mongoose.model('Users', usersSchema);

export default User
