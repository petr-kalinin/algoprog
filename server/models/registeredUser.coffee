mongoose = require('mongoose')
passportLocalMongoose = require('passport-local-mongoose')

registeredUserSchema = new mongoose.Schema
    admin: Boolean
    ejudgeUsername: String
    ejudgePassword: String
    informaticsId: Number
    aboutme: String

registeredUserSchema.statics.findAdmin = (list) ->
    RegisteredUser.findOne({admin: true, username: "pkalinin"})


registeredUserSchema.plugin(passportLocalMongoose);

RegisteredUser = mongoose.model('registeredUser', registeredUserSchema);

export default RegisteredUser
