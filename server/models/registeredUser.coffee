mongoose = require('mongoose')
passportLocalMongoose = require('passport-local-mongoose')

registeredUserSchema = new mongoose.Schema
    admin: Boolean
    adminData:
        defaultUserLists: [String]
    informaticsUsername: String
    informaticsPassword: String
    informaticsId: Number
    promo: String
    contact: String
    whereFrom: String
    aboutme: String

registeredUserSchema.statics.findAdmin = (list) ->
    RegisteredUser.findOne({admin: true, username: "pkalinin"})

registeredUserSchema.statics.findByKey = (key) ->
    RegisteredUser.findOne({informaticsId: key})

registeredUserSchema.statics.findAllByKey = (key) ->
    RegisteredUser.find({informaticsId: key})

registeredUserSchema.methods.userKey = () ->
    @informaticsId
    
registeredUserSchema.plugin(passportLocalMongoose);

RegisteredUser = mongoose.model('registeredUser', registeredUserSchema);

export default RegisteredUser
