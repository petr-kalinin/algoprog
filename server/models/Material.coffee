mongoose = require('mongoose')

import logger from '../log'

materialsSchema = new mongoose.Schema
    _id: String
    order: Number
    type: String
    indent: Number
    title: String
    content: String
    level: String
    path: [{_id: String, title: String}]
    materials: [mongoose.Schema.Types.Mixed]  # will always be an array of dictionaries
    force: { type: Boolean, default: false }
    

materialsSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a material"

materialsSchema.methods.allowedForUser = (user) ->
    if not @level
        return true
    if not user?.level?.current?
        return false
    effectiveLevel = @level
    if @level.startsWith("reg") or @level.startsWith("roi")
        effectiveLevel = "2"
    return user.level.current >= effectiveLevel


Material = mongoose.model('Materials', materialsSchema);

export default Material
