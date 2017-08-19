mongoose = require('mongoose')

import logger from '../log'

materialsSchema = new mongoose.Schema
    _id: String
    order: Number
    type: String
    indent: Number
    title: String
    content: String
    materials: [mongoose.Schema.Types.Mixed]  # will always be an array of dictionaries

materialsSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a material"

Material = mongoose.model('Materials', materialsSchema);

export default Material
