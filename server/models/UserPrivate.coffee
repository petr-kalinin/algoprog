mongoose = require('mongoose')

import logger from '../log'

usersPrivateSchema = new mongoose.Schema
    _id: String,
    paidTill: Date,
    price: Number

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

usersPrivateSchema.methods.setPrice = (price) ->
    logger.info "setting price id ", @_id, price
    await @update({$set: {"price": price}})
    @price = price

UserPrivate = mongoose.model('shadUsersPrivate', usersPrivateSchema);

export default UserPrivate
