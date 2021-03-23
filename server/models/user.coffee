mongoose = require('mongoose')

import awaitAll from '../../client/lib/awaitAll'

import calculateChocos from '../calculations/calculateChocos'
import calculateRatingEtc from '../calculations/calculateRatingEtc'
import calculateLevel from '../calculations/calculateLevel'
import calculateCfRating from '../calculations/calculateCfRating'
import calculateAchieves from '../calculations/calculateAchieves'
import updateResults from '../calculations/updateResults'
import updateTableResults from '../calculations/updateTableResults'
import calculateCalendar from '../calculations/calculateCalendar'

import InformaticsUser from '../informatics/InformaticsUser'

import sleep from '../lib/sleep'

import logger from '../log'

import RegisteredUser from '../models/registeredUser'

import getTestSystem from '../testSystems/TestSystemRegistry'


SEMESTER_START = "2016-06-01"
DORMANT_TIME = 1000 * 60 * 60 * 24 * 3
DEACTIVATED_DORMANT_TIME = 1000 * 60 * 60 * 24 * 90

usersSchema = new mongoose.Schema
    _id: String,
    name: String,
    userList: String,
    mainUserList: String
    activated: Boolean,
    chocos: [Number],
    chocosGot: [Number],
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
        progress: Number,
    graduateYear: Number,
    lastActivated: Date,
    dormant: { type: Boolean, default: false },
    registerDate: Date,
    achieves: [String]
    prefs:
        editorOn: Boolean

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

usersSchema.methods.updateDormant = ->
    date = new Date()
    if not @activated && @lastActivated && date-@lastActivated > (if @userList=="unknown" then DORMANT_TIME else DEACTIVATED_DORMANT_TIME)
        @dormant = true
        await @update({$set: {dormant: @dormant}})

usersSchema.methods.updateCfRating = ->
    oldRating = @cf?.rating
    logger.debug "Updating cf rating ", @name
    res = await calculateCfRating this
    logger.debug "Updated cf rating ", @name, res
    if not res
        return
    res.login = @cf.login
    await @update({$set: {cf: res}})
    @cf = res
    return @cf.rating != oldRating

usersSchema.methods.updateAchieves = (achieves) ->
    logger.info "updating achieves login ", @_id, achieves
    @achieves = await calculateAchieves(this)
    await @update({$set: {"achieves": @achieves}})

usersSchema.methods.updateGraduateYear = ->
    registeredUser = await RegisteredUser.findByKeyWithPassword(@_id)
    if not registeredUser
        return
    informaticsUser = await InformaticsUser.getUser(registeredUser.informaticsUsername, registeredUser.informaticsPassword)
    data = await informaticsUser.getData()
    @update({$set: {graduateYear: data.graduateYear}})

usersSchema.methods.randomizeEjudgePassword = ->
    registeredUsers = await RegisteredUser.findAllByKeyWithPassword(@_id)
    system = getTestSystem("ejudge")
    await system.randomizePassword(registeredUsers)

usersSchema.methods.setGraduateYear = (graduateYear) ->
    logger.info "setting graduateYear id ", @_id, graduateYear
    await @update({$set: {"graduateYear": graduateYear}})
    @graduateYear = graduateYear

usersSchema.methods.updateName = (name) ->
    logger.info "Set name for user", @_id,": old name " ,@name,", new name " ,name
    await @update({$set: {"name": name}})
    @name = name

usersSchema.methods.setBaseLevel = (level) ->
    await @update({$set: {"level.base": level}})
    @level.base = level
    await @updateLevel()
    @updateRatingEtc()

usersSchema.methods.setCfLogin = (cfLogin) ->
    logger.info "setting cf login ", @_id, cfLogin
    await @update({$set: {"cf.login": cfLogin}})
    @cf.login = cfLogin
    if(cfLogin != undefined)
        @updateCfRating()
    else
        await @update({$unset: {"cf.rating": "", "cf.login":"", "cf.color":"", "cf.activity":"", "cf.progress":""}})

usersSchema.methods.setAchieves = (achieves) ->
    logger.info "setting achieves login ", @_id, achieves
    await @update({$set: {"achieves": achieves}})
    @achieves = achieves

usersSchema.methods.setChocosGot = (chocosGot) ->
    logger.info "setting chocosGot ", @_id, chocosGot 
    await @update({$set: {"chocosGot": chocosGot}})
    @chocosGot = chocosGot

usersSchema.methods.setUserList = (userList) ->
    logger.info "setting userList ", @_id, userList
    @lastActivated = Date.now()
    await @update({$set: {"lastActivated": @lastActivated, "userList": userList, "activated": true, "dormant": false}})
    @userList = userList
    User.updateUser(@_id)
    return undefined

usersSchema.methods.forceSetUserList = (userList) ->
    logger.info "force-setting userList ", @_id, userList
    await @update({$set: {"userList": userList}})
    @userList = userList
    #User.updateUser(@_id)
    return undefined

usersSchema.methods.setDormant = (dormant) ->
    logger.info "setting dormant ", @_id, dormant
    await @update({$set: {"dormant": dormant}})
    await User.updateUser(@_id)
    @dormant = dormant

usersSchema.methods.setActivated = (activated) ->
    logger.info "setting activated ", @_id, activated
    await @update({$set: {"activated": activated}})
    User.updateUser(@_id)
    @activated = activated

usersSchema.methods.setEditorOn = (editorOn) ->
    logger.info "set editor on ", @name, editorOn
    @prefs.editorOn = editorOn
    @save()

compareLevels = (a, b) ->
    if a.length != b.length
        return if a.length > b.length then -1 else 1
    if a != b
        return if a > b then -1 else 1
    return 0

sortByLevelAndRating = (a, b) ->
    if a.active != b.active
        return if a.active then -1 else 1
    if a.level.current != b.level.current
        return compareLevels(a.level.current, b.level.current)
    if a.rating != b.rating
        return if a.rating > b.rating then -1 else 1
    return 0

usersSchema.statics.sortByLevelAndRating = sortByLevelAndRating

usersSchema.statics.findByList = (list) ->
    result = await User.find({userList: list, dormant: false})
    return result.sort(sortByLevelAndRating)

usersSchema.statics.search = (searchString) ->
    await User.find({$or: [{name: {$regex: searchString, $options: 'i'}}, {_id: {$regex: searchString, $options: 'i'}}, {userList: {$regex: searchString, $options: 'i'}}]})

usersSchema.statics.findAll = () ->
    User.find({dormant: false})

usersSchema.statics.findAllAll = () ->
    User.find({})

usersSchema.statics.findById = (id) ->
    User.findOne({_id: id})

usersSchema.statics.findByAchieve = (achieve) ->
    User.find({achieves: achieve}).sort({ratingSort: -1})

usersSchema.statics.updateUser = (userId, dirtyResults) ->
    start = new Date()
    logger.info ">>Updating user", userId
    await updateResults(userId, dirtyResults)
    await updateTableResults(userId)
    await calculateCalendar(userId)
    u = await User.findById(userId)
    if not u
        logger.warn "Unknown user ", userId
        return
    await u.updateChocos()
    await u.updateRatingEtc()
    await u.updateLevel()
    await u.updateDormant()
    await u.updateAchieves()
    logger.info "<<Updated user", userId, " spent time ", (new Date()) - start

usersSchema.statics.updateAllUsers = (dirtyResults, alsoDormant) ->
    PARALLEL = 5
    tryUpdate = (id) ->
        try
            await User.updateUser(id)
        catch e
            logger.warn("Error while updating user: ", e.message || e, e.stack)

    users = []
    if alsoDormant
        users = await User.findAllAll()
    else
        users = await User.findAll()
    promises = []
    count = 0
    for u in users
        promises.push(tryUpdate(u._id))
        count++
        if promises.length >= PARALLEL
            logger.info("Updating #{PARALLEL} users, waiting for completion (#{count} / #{users.length})")
            await awaitAll(promises)
            logger.info("Updated #{PARALLEL} users, continuing (#{count} / #{users.length})")
            promises = []
    await awaitAll(promises)
    logger.info("Updated all users")

usersSchema.statics.randomizeEjudgePasswords = () ->
    PARALLEL = 10
    tryUpdate = (user) ->
        try
            await user.randomizeEjudgePassword()
        catch e
            logger.warn("Error while updating user: ", e.message || e, e.stack)

    users = await User.findAllAll()
    promises = []
    count = 0
    for u in users
        promises.push(tryUpdate(u))
        count++
        if promises.length >= PARALLEL
            logger.info("Randomizing #{PARALLEL} users, waiting for completion (#{count} / #{users.length})")
            await awaitAll(promises)
            logger.info("Randomized #{PARALLEL} users, continuing (#{count} / #{users.length})")
            promises = []
    await awaitAll(promises)
    logger.info("Randomized all users")

usersSchema.statics.updateAllCf = () ->
    logger.info "Updating cf ratings"
    for u in await User.findAll()
        if u.cf.login
            if await u.updateCfRating()
                await User.updateUser(u._id, {})
            await sleep(500)  # don't hit CF request limit
    logger.info "Updated cf ratings"

usersSchema.statics.updateAllGraduateYears = () ->
    logger.info "Updating graduateYear"
    promises = []
    for u in await User.findAll()
        if !u.graduateYear
            promises.push(u.updateGraduateYear())
    await awaitAll promises
    logger.info "Updated graduateYear"

usersSchema.index
    dormant: 1
    userList: 1
    active: -1
    level: -1
    ratingSort: -1

usersSchema.index
    dormant: 1
    username: 1

usersSchema.index
    achieves: 1
    ratingSort: -1

User = mongoose.model('Users', usersSchema);

export default User
