mongoose = require('mongoose')

import User from './user'
import logger from '../log'
import {runMongooseCallback} from '../mongo/MongooseCallbackManager'

resultsSchema = new mongoose.Schema
    _id: String
    user: String
    userList: String
    activated: Boolean
    table: String
    total: Number
    required: Number  # number of problems from non-star subcontests, not the number of required problems on level
    solved: Number
    ps: Number
    ok: Number
    attempts: Number
    lastSubmitId: String
    lastSubmitTime: Date
    ignored: Number
    findMistake: String
    subFindMistakes:
        ok: Number
        wa: Number
        none: Number

resultsSchema.methods.upsert = () ->
    # required: user, table, total, solved, ok, attempts, ignored, lastSubmitId, lastSubmitTime
    user = await User.findById(@user)
    if not user
        logger.warn "Unknown user #{@user} in Result.upsert, result id #{@_id}"
        return
    @userList = user.userList
    @activated = user?.activated
    @_id = @user + "::" + (@findMistake || @table)
    await @update(this, {upsert: true}).exec()
    runMongooseCallback 'update_result', @user

resultsSchema.statics.DQconst = -10

resultsSchema.statics.findByUserListAndTable = (userList, table) ->
    tableList = await Table.findById(table).descendandTables()
    return Result.find({
        userList: userList,
        table: {$in: tableList}
        findMistake: null
    }).sort { solved: -1, attempts: 1}

resultsSchema.statics.findByUserList = (userList) ->
    return Result.find({
        userList: userList
        findMistake: null
    }).sort { solved: -1, attempts: 1}

resultsSchema.statics.findByUser = (userId) ->
    return Result.find
        user: userId
        findMistake: null

resultsSchema.statics.findByUserWithFindMistakeSet = (userId) ->
    return Result.find
        user: userId
        findMistake: {$ne: null}

resultsSchema.statics.findByUserAndTable = (userId, tableId) ->
    key = userId + "::" + tableId
    return Result.findOne
            _id: userId + "::" + tableId
            findMistake: null

resultsSchema.statics.findLastWA = (limit) ->
    return Result.find({
        total: 1,  # this is a problem, not a contest
        solved: 0,
        ok: 0,
        ignored: 0,
        attempts: {$gte: 1},
        findMistake: null
    }).sort({ lastSubmitTime: -1 }).limit(limit)


resultsSchema.index
    userList: 1
    table : 1
    findMistake: 1
    solved: -1
    attempts: 1

resultsSchema.index
    userList: 1
    findMistake: 1
    solved: -1
    attempts: 1

resultsSchema.index
    user: 1
    table: 1
    findMistake: 1

resultsSchema.index
    total: 1
    solved: 1
    ok: 1
    ignored: 1
    attempts: 1
    findMistake: 1
    lastSubmitTime: -1

resultsSchema.index
    total: 1
    ps: 1

resultsSchema.index
    ok: 1
    total: 1
    lastSubmitTime: -1
    findMistake: 1
    activated: 1

resultsSchema.index
    ok: 1
    total: 1
    lastSubmitTime: -1
    findMistake: 1
    activated: 1
    userList: 1

resultsSchema.index
    ps: 1
    total: 1
    findMistake: 1
    activated: 1
    userList: 1

resultsSchema.index
    solved: 1
    ok: 1
    ignored: 1
    attempts: 1
    total: 1
    findMistake: 1
    activated: 1
    userList: 1

resultsSchema.index
    ignored: 1
    total: 1
    findMistake: 1
    activated: 1
    userList: 1

resultsSchema.index
    solved: 1
    total: 1
    findMistake: 1
    activated: 1
    userList: 1

Result = mongoose.model('Results', resultsSchema);


export default Result
