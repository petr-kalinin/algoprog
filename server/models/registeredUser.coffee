mongoose = require('mongoose')
passportLocalMongoose = require('passport-local-mongoose')

registeredUserSchema = new mongoose.Schema
    admin: Boolean

registeredUserSchema.plugin(passportLocalMongoose);

RegisteredUser = mongoose.model('registeredUser', registeredUserSchema);

export default RegisteredUser
