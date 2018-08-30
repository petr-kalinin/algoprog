mongoose = require('mongoose')
passportLocalMongoose = require('passport-local-mongoose')

registeredUserSchema = new mongoose.Schema
    admin: Boolean
    adminData:
        defaultUserLists: [String]
    ejudgeUsername: String
    ejudgePassword: String
    informaticsId: Number
    promo: String
    contact: String
    whereFrom: String
    aboutme: String

registeredUserSchema.statics.findAdmin = (list) ->
    RegisteredUser.findOne({admin: true, username: "pkalinin"}).select("+informaticsPassword")

registeredUserSchema.statics.findByKey = (key) ->
    RegisteredUser.findOne({informaticsId: key})

registeredUserSchema.statics.search = (searchString) ->
    RegisteredUser.find({$or: [{username: {$regex: searchString, $options: 'i'}}, {informaticsUsername: {$regex: searchString, $options: 'i'}}]})

registeredUserSchema.statics.findAllByKey = (key) ->
    await RegisteredUser.find({informaticsId: key})

registeredUserSchema.statics.findByKeyWithPassword = (key) ->
    await RegisteredUser.findOne({informaticsId: key}).select("+informaticsPassword")

registeredUserSchema.methods.userKey = () ->
    @informaticsId
    
registeredUserSchema.plugin(passportLocalMongoose);

RegisteredUser = mongoose.model('registeredUser', registeredUserSchema);

export default RegisteredUser
