mongoose = require('mongoose')

import logger from '../log'

materialsSchema = new mongoose.Schema
    _id: String
    order: Number
    type: String
    text: String
    href: String
    materials: [String]
        
materialsSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a material"
    
Material = mongoose.model('Materials', materialsSchema);

export default Material
