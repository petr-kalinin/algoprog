mongoose = require('mongoose')

import logger from '../log'

materialsSchema = new mongoose.Schema
    _id: String
    type: String
    title: String
    content: String
    level: String
    path: [{_id: String, title: String}]
    materials: [mongoose.Schema.Types.Mixed]  # will always be an array of dictionaries
    force: { type: Boolean, default: false }
    testSystemData: mongoose.Schema.Types.Mixed
    order: String
    

materialsSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a material"

export isLevelAllowedForUser = (level, user) ->
    if not level
        return true
    if not user?.level?.current?
        return false
    effectiveLevel = level
    if level.startsWith("reg") or level.startsWith("roi")
        effectiveLevel = "2"
    return user.level.current >= effectiveLevel


materialsSchema.methods.allowedForUser = (user) ->
    return isLevelAllowedForUser(@level, user)


materialsSchema.statics.findByType = (type) ->
    Material.find
        type: type

Material = mongoose.model('Materials', materialsSchema);

export default Material
