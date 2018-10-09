mongoose = require('mongoose')

import logger from '../log'

materialsSchema = new mongoose.Schema
    _id: String
    order: Number
    type: String
    indent: Number
    title: String
    content: String
    path: [{_id: String, title: String}]
    materials: [mongoose.Schema.Types.Mixed]  # will always be an array of dictionaries
    force: { type: Boolean, default: false }
    isReview: { type: Boolean, default: false }
    

materialsSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a material"

Material = mongoose.model('shadMaterials', materialsSchema);

export default Material
