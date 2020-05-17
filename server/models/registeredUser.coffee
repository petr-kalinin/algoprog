mongoose = require('mongoose')
passportLocalMongoose = require('passport-local-mongoose')

registeredUserSchema = new mongoose.Schema
    admin: Boolean
    adminData:
        defaultUserLists: [String]
    informaticsUsername: String
    informaticsPassword: {type: String, select: false}
    informaticsId: Number
    ejudgeUsername: String
    ejudgePassword: {type: String, select: false}
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
    RegisteredUser.findOne({admin: true, username: "pkalinin"}).select("+informaticsPassword +ejudgePassword")

registeredUserSchema.statics.findByKey = (key) ->
    RegisteredUser.findOne({informaticsId: key})

registeredUserSchema.statics.search = (searchString) ->
    RegisteredUser.find({$or: [{username: {$regex: searchString, $options: 'i'}}, {informaticsUsername: {$regex: searchString, $options: 'i'}}]})

registeredUserSchema.statics.findAllByKey = (key) ->
    await RegisteredUser.find({informaticsId: key})

registeredUserSchema.statics.findByKeyWithPassword = (key) ->
    await RegisteredUser.findOne({informaticsId: key}).select("+informaticsPassword +ejudgePassword")

registeredUserSchema.methods.userKey = () ->
    @informaticsId
    
registeredUserSchema.plugin(passportLocalMongoose);

RegisteredUser = mongoose.model('registeredUser', registeredUserSchema);

export default RegisteredUser
