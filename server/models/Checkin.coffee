mongoose = require('mongoose')

checkinSchema = new mongoose.Schema
    user: String
    session: Number
    checkinTime: Date
    deleted: { type: Boolean, default: false }
    deletedTime: Date

checkinSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @checkinTime = new Date()
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a checkin"

checkinSchema.methods.markDeleted = () ->
    @deleted = true
    @deletedTime = new Date()
    @update(this)

checkinSchema.statics.findBySession = (session) ->
    Checkin.find
        session: session
        deleted: false

checkinSchema.statics.findByUser = (user) ->
    Checkin.find
        user: user
        deleted: false

checkinSchema.index({ deleted: 1, session : 1 })
checkinSchema.index({ deleted: 1, user : 1 })

Checkin = mongoose.model('Checkins', checkinSchema);

export default Checkin

export MAX_CHECKIN_PER_SESSION = [1, 1]
