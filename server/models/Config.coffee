mongoose = require('mongoose')

configSchema = new mongoose.Schema
    _id: String
    data: mongoose.Schema.Types.Mixed

configSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a material"

configSchema.statics.set = (id, data) ->
    config = new Config
        _id: id
        data: data
    await config.upsert()

configSchema.statics.get = (id) ->
    config = await Config.findById(id)
    return config?.toObject?()?.data
    
Config = mongoose.model('Configs', configSchema);

export default Config
