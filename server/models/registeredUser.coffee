mongoose = require('mongoose')
passportLocalMongoose = require('passport-local-mongoose')

registeredUserSchema = new mongoose.Schema
    admin: Boolean
    informaticsUsername: String
    informaticsPassword: String
    informaticsId: Number
    aboutme: String

registeredUserSchema.statics.findAdmin = (list) ->
    RegisteredUser.findOne({admin: true})


registeredUserSchema.plugin(passportLocalMongoose);

RegisteredUser = mongoose.model('registeredUser', registeredUserSchema);

export default RegisteredUser
