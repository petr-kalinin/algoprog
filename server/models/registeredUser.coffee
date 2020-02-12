mongoose = require('mongoose')
passportLocalMongoose = require('passport-local-mongoose')

registeredUserSchema = new mongoose.Schema
    admin: Boolean
    adminData:
        defaultUserLists: [String]
    ejudgeUsername: String
    ejudgePassword: {type: String, select: false}
    promo: String
    contact: String
    whereFrom: String
    aboutme: String

registeredUserSchema.statics.findAdmin = (list) ->
    RegisteredUser.findOne({admin: true, username: "pkalinin"}).select("+ejudgePassword")


registeredUserSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a registeredUser"

registeredUserSchema.methods.userKey = () ->
    @ejudgeUsername
    
registeredUserSchema.statics.findByKey = (key) ->
    RegisteredUser.findOne({ejudgeUsername: key})

registeredUserSchema.statics.search = (searchString) ->
    RegisteredUser.find({$or: [{username: {$regex: searchString, $options: 'i'}}, {informaticsUsername: {$regex: searchString, $options: 'i'}}]})

registeredUserSchema.statics.findAllByKey = (key) ->
    await RegisteredUser.find({ejudgeUsername: key})

registeredUserSchema.statics.findByKeyWithPassword = (key) ->
    await RegisteredUser.findOne({ejudgeUsername: key}).select("+ejudgePassword")
    
registeredUserSchema.plugin(passportLocalMongoose);

RegisteredUser = mongoose.model('smRegisteredUser', registeredUserSchema);

export default RegisteredUser
