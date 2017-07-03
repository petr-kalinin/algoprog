mongoose = require('mongoose')

usersSchema = new mongoose.Schema
    _id: String,
    name: String,
    userList: String,
    chocos: [Number],
    level:
        currrent: String,
        start: String,
        base: String,
    active: Boolean,
    ratingSort: Number,
    byWeek: [{solved: Number, ok: Number}],
    rating: Number,
    activity: Number,
    cf:
        login: Number,
        rating: Number,
        color: Number,
        activity: Number,
        progress: Number
        
usersSchema.methods.upsert = () ->
    User.update({_id: @_id}, this, {upsert: true}).exec()

User = mongoose.model('Users', usersSchema);

export default User
