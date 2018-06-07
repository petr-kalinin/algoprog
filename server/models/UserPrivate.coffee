mongoose = require('mongoose')

import logger from '../log'

usersPrivateSchema = new mongoose.Schema
    _id: String,
    paidTill: Date

usersPrivateSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        console.log "upserting userPrivate", this
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a userPrivate"

usersPrivateSchema.methods.setPaidTill = (paidTill) ->
    logger.info "setting paidTill id ", @_id, paidTill
    await @update({$set: {"paidTill": paidTill}})
    @paidTill = paidTill

UserPrivate = mongoose.model('UsersPrivate', usersPrivateSchema);

export default UserPrivate
