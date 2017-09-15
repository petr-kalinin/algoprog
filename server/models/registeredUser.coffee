mongoose = require('mongoose')
passportLocalMongoose = require('passport-local-mongoose')

registeredUserSchema = new mongoose.Schema
    admin: Boolean
    informaticsUsername: String
    informaticsPassword: String
    informaticsId: Number
    aboutme: String

registeredUserSchema.plugin(passportLocalMongoose, {selectFields: ["admin", "informaticsId"]});

RegisteredUser = mongoose.model('registeredUser', registeredUserSchema);

export default RegisteredUser
