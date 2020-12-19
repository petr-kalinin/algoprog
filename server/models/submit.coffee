mongoose = require('mongoose')

import Hash from './Hash'
import User from './user'

import calculateHashes from '../hashes/calculateHashes'
import normalizeCode from '../lib/normalizeCode'
import {runMongooseCallback} from '../mongo/MongooseCallbackManager'

import awaitAll from '../../client/lib/awaitAll'
import logger from '../log'

outcomeType = (outcome) ->
    switch outcome
        when "DR" then "DR"
        when "PS" then "PS"
        else "_"

submitsSchema = new mongoose.Schema
    _id: String
    time: Date
    downloadTime: { type: Date, default: new Date(0) }
    user: String
    userList: String
    problem: String
    outcome: String
    source: String
    sourceRaw: String
    language: String
    comments: [String]
    results: mongoose.Schema.Types.Mixed
    force: { type: Boolean, default: false },
    quality: { type: Number, default: 0 },
    hashes: [{window: Number, hash: String, score: Number}]
    testSystemData: mongoose.Schema.Types.Mixed
    findMistake: String
    
submitsSchema.methods.upsert = () ->
    await @update(this, {upsert: true, overwrite: true})
    runMongooseCallback 'update_submit', @user

submitsSchema.methods.calculateHashes = () ->
    logger.info("calculating hashes for submit #{@_id}")
    @hashes = calculateHashes((@sourceRaw or @source).toString())
    logger.info("calculating hashes for submit #{@_id}, have #{@hashes.length} hashes")
    for h in @hashes
        if @outcome in ['OK', 'IG']
            h.score *= 2
        if @outcome == 'AC'
            h.score *= 3
        hash = new Hash
            _id: "#{h.hash}:#{@_id}"
            hash: h.hash
            submit: @_id
            user: @user
            problem: @problem
            window: h.window
            score: h.score
        await hash.upsert()
    await @upsert()

submitsSchema.methods.equivalent = (other) ->
    if @comments.length > 0
        return false
    if @outcome == "AC" or @outcome == "IG" or @outcome == "DQ"
        return false
    if @force
        return false
    otherCodes = [normalizeCode(other.source), normalizeCode(other.sourceRaw)]
    return @user == other.user \
        and @problem == other.problem \
        and outcomeType(@outcome) == outcomeType(other.outcome) \
        and ((normalizeCode(@source) in otherCodes) or (normalizeCode(@sourceRaw) in otherCodes)) \
        and (@language == other.language \
             or Math.abs(@time - other.time) < 1500 \
             or Math.abs(Math.abs(@time - other.time) - 3 * 60 * 60 * 1000) < 1500)

submitsSchema.statics.findByUser = (userId) ->
    Submit.find
        user: userId
        findMistake: null

submitsSchema.statics.findByUserWithFindMistakeAny = (userId) ->
    Submit.find
        user: userId

submitsSchema.statics.findByUserAndDayWithFindMistakeAny = (userId, day) ->
    date = new Date(Date.parse(day))
    start = new Date(date)
    end = new Date(date)
    start.setHours(0,0,0,0);
    end.setHours(23,59,59,999)
    Submit.find
        user: userId
        time: {$gte: start, $lt: end}

submitsSchema.statics.findByUserAndProblem = (userId, problemId) ->
    Submit.find({
        user: userId
        problem: problemId
        findMistake: null
    }).sort({time: 1})

submitsSchema.statics.findByUserAndProblemWithFindMistakeSet = (userId, problemId) ->
    Submit.find({
        user: userId
        problem: problemId
        findMistake: {$ne: null}
    }).sort({time: 1})

submitsSchema.statics.findByUserAndProblemWithFindMistakeAny = (userId, problemId) ->
    Submit.find({
        user: userId
        problem: problemId
    }).sort({time: 1})

submitsSchema.statics.findByUserAndFindMistake = (userId, findMistakeId) ->
    Submit.find({
        user: userId
        findMistake: findMistakeId
    }).sort({time: 1})

submitsSchema.statics.findBestByProblem = (problemId, limit) ->
    Submit.find({
        problem: problemId,
        quality: {$gt: 0}
        findMistake: null
    })
        .sort({quality: -1, time: -1})
        .select({results: 0, comments: 0, force: 0})
        .limit(limit)

submitsSchema.statics.findLastNotCT = () ->
    for submit in await Submit.find({outcome: {$ne: "CT"}}).sort({time: -1}).limit(1)
        return submit

submitsSchema.statics.findPendingSubmits = (userId) ->
    Submit.find
        outcome: "PS"
        
submitsSchema.statics.findCT = (userId) ->
    Submit.find
        outcome: "CT"

submitsSchema.statics.calculateAllHashes = () ->
    users = await User.find({})
    for u, userI in users
        submits = await Submit.findByUser(u._id)
        promises = []
        count = 0
        for s in submits
            promises.push(s.calculateHashes())
            count++
            if promises.length >= 10
                logger.info("Calculating 10 hashes, waiting for completion (#{count} / #{submits.length}  | #{userI} / #{users.length})")
                await awaitAll(promises)
                logger.info("Calculated 10 hashes, continuing (#{count} / #{submits.length}  | #{userI} / #{users.length})")
                promises = []
        await awaitAll(promises)
        logger.info("Calculated all hashes for user #{userI} / #{users.length}")
    logger.info("Calculated all hashes for all users")

submitsSchema.index({ user : 1, problem: 1, findMistake: 1, time: 1 })
submitsSchema.index({ user : 1, findMistake: 1, time: 1 })
submitsSchema.index({ user : 1, problem: 1, outcome: 1 })
submitsSchema.index({ outcome : 1, time : 1 })
submitsSchema.index({ time : 1 })
submitsSchema.index({ problem: 1, quality : -1, time: -1 })

Submit = mongoose.model('Submits', submitsSchema);

export default Submit
