mongoose = require('mongoose')

hashSchema = new mongoose.Schema
    _id: String
    hash: String
    submit: String
    user: String
    window: Number 

hashSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a hash"

hashSchema.index({ _id : 1, user: 1 })

Hash = mongoose.model('Hash', hashSchema);

export default Hash
