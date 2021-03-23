mongoose = require('mongoose')
passportLocalMongoose = require('passport-local-mongoose')

import logger from '../log'

registeredUserSchema = new mongoose.Schema
    admin: Boolean
    adminData:
        defaultUserLists: [String]
    informaticsUsername: String
    informaticsPassword: {type: String, select: false}
    informaticsId: Number
    ejudgeUsername: String
    ejudgePassword: {type: String, select: false}
    codeforcesUsername: String
    codeforcesPassword: {type: String, select: false}
    promo: String
    contact: String
    whereFrom: String
    aboutme: String


registeredUserSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a registereduser"    

registeredUserSchema.statics.findAdmin = (list) ->
    RegisteredUser.findOne({admin: true, username: "pkalinin"}).select("+informaticsPassword +ejudgePassword +codeforcesPassword")

registeredUserSchema.statics.findByKey = (key) ->
    RegisteredUser.findOne({informaticsId: key})

registeredUserSchema.statics.search = (searchString) ->
    RegisteredUser.find({$or: [{username: {$regex: searchString, $options: 'i'}}, {informaticsUsername: {$regex: searchString, $options: 'i'}}]})

registeredUserSchema.statics.findAllByKey = (key) ->
    await RegisteredUser.find({informaticsId: key})

registeredUserSchema.statics.findByKeyWithPassword = (key) ->
    await RegisteredUser.findOne({informaticsId: key}).select("+informaticsPassword +ejudgePassword +codeforcesPassword")

registeredUserSchema.statics.findAllByKeyWithPassword = (key) ->
    await RegisteredUser.find({informaticsId: key}).select("+informaticsPassword +ejudgePassword +codeforcesPassword")

registeredUserSchema.methods.userKey = () ->
    @informaticsId

registeredUserSchema.methods.updateInformaticPassword = (password) ->
    logger.info "setting InformaticsPassword ", password 
    await @update({$set: {"informaticsPassword": password}})
    @informaticsPassword = password

registeredUserSchema.methods.setCodeforces = (username, password) ->
    logger.info "setting codeforces data for user #{@userKey()}"
    await @update({$set: {codeforcesUsername: username, codeforcesPassword: password}})
    @codeforcesUsername = username
    @codeforcesPassword = password
    
registeredUserSchema.plugin(passportLocalMongoose);

RegisteredUser = mongoose.model('registeredUser', registeredUserSchema);

export default RegisteredUser
