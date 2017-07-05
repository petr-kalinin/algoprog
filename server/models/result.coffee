mongoose = require('mongoose')

import User from './user'

resultsSchema = new mongoose.Schema
    _id: String
    user: String
    userList: String
    table: String
    total: Number
    solved: Number
    ok: Number
    attempts: Number
    lastSubmitId: String
    lastSubmitTime: Date
    ignored: Number   # for problems only, can be 0 or 1
        

resultsSchema.methods.upsert = () ->
    # required: user, table, total, solved, ok, attempts, ignored, lastSubmitId, lastSubmitTime
    @userList = await User.findById(@user).userList
    @_id = @user + "::" + @table
    Result.update({_id: @_id}, this, {upsert: true}).exec()

    
resultsSchema.statics.DQconst = -10

resultsSchema.statics.findByUserListAndTable = (userList, table) ->
    tableList = Table.findById(table).descendandTables()
    return Result.find({
        userList: userList, 
        table: {$in: tableList}
    }).sort { solved: -1, attempts: 1}
        
resultsSchema.statics.findByUserList = (userList) ->
    return Result.find({
        userList: userList
    }).sort { solved: -1, attempts: 1}
        
resultsSchema.statics.findByUser = (userId) ->
    return Result.find
        user: userId

resultsSchema.statics.findByUserAndTable = (userId, tableId) ->
    key = userId + "::" + tableId
    return Result.findOne
            _id: userId + "::" + tableId

resultsSchema.statics.findLastWA = (limit) ->
    return Result.find({
        total: 1,  # this is a problem, not a contest
        solved: 0,
        ok: 0,
        ignored: 0,
        attempts: {$gte: 1},
    }).sort({ lastSubmitTime: -1 }).limit(limit)
    
Result = mongoose.model('Results', resultsSchema);

export default Result
