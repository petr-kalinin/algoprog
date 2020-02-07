mongoose = require('mongoose')

hashSchema = new mongoose.Schema
    _id: String
    hash: String
    submit: String
    user: String
    problem: String
    window: Number
    score: Number

hashSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a hash"

hashSchema.statics.findByHashAndNotUser = (hash, user) ->
    Hash.find
        hash: hash
        user: {$ne: user}

hashSchema.statics.removeForSubmit = (submit) ->
    Hash.remove
        submit: submit

hashSchema.index({ hash : 1, user: 1 })

Hash = mongoose.model('smHash', hashSchema);

export default Hash
