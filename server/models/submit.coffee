mongoose = require('mongoose')

import Hash from './Hash'
import User from './user'

import calculateHashes from '../hashes/calculateHashes'
import normalizeCode from '../lib/normalizeCode'

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
    
submitsSchema.methods.upsert = () ->
    @update(this, {upsert: true, overwrite: true})

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
    if @user == "394891" and @_id == "18336986p2951" and other._id == "2088r683956p2951"
        logger.log "Compare submits ", @_id, other._id, @comments.length > 0, @outcome == "AC" or @outcome == "IG" or @outcome == "DQ", @force, @user == other.user, @problem == other.problem, outcomeType(@outcome) == outcomeType(other.outcome), @source.replace(/\r/g, "") == other.source.replace(/\r/g, ""), Math.abs(@time - other.time)
        s1 = normalizeCode(@source)
        s2 = normalizeCode(other.source)
        logger.log "s1,s2.length=", s1.length, s2.length, @_id, other._id
        ll = ""
        ll += "s1,s2.length=#{s1.length}, #{s2.length} "
        for i in [0..s1.length - 1]
            logger.log i, s1.charCodeAt(i), s2.charCodeAt(i), @_id, other._id
            ll += "[#{i}, #{s1.charCodeAt(i)}, #{s2.charCodeAt(i)}]"
            if s1.charAt(i) != s2.charAt(i)
                logger.log "bad", i, s1.charCodeAt(i), s2.charCodeAt(i), @_id, other._id
                ll += "^"
        logger.log "ll=", ll
    if @comments.length > 0
        return false
    if @outcome == "AC" or @outcome == "IG" or @outcome == "DQ"
        return false
    if @force
        return false
    return @user == other.user \
        and @problem == other.problem \
        and outcomeType(@outcome) == outcomeType(other.outcome) \
        and normalizeCode(@source) == normalizeCode(other.source) \
        and (@language == other.language \
             or Math.abs(@time - other.time) < 1500 \
             or Math.abs(Math.abs(@time - other.time) - 3 * 60 * 60 * 1000) < 1500)

submitsSchema.statics.findByUser = (userId) ->
    Submit.find
        user: userId

submitsSchema.statics.findByUserAndProblem = (userId, problemId) ->
    Submit.find({
        user: userId
        problem: problemId
    }).sort({time: 1})

submitsSchema.statics.findBestByProblem = (problemId, limit) ->
    Submit.find({
        problem: problemId,
        quality: {$gt: 0}
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

submitsSchema.index({ user : 1, problem: 1, time: 1 })
submitsSchema.index({ user : 1, problem: 1, outcome: 1 })
submitsSchema.index({ outcome : 1, time : 1 })
submitsSchema.index({ time : 1 })
submitsSchema.index({ problem: 1, quality : -1, time: -1 })

Submit = mongoose.model('Submits', submitsSchema);

export default Submit
