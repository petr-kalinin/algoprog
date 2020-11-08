mongoose = require('mongoose')
import logger from '../log'

mongoose.Promise = global.Promise;

if process.env.MONGODB_HOST and process.env.MONGO_USER and process.env.MONGO_PASSWORD
    url = "mongodb://#{process.env.MONGO_USER}:#{process.env.MONGO_PASSWORD}@#{process.env.MONGODB_HOST}/algoprog"
else if process.env.MONGODB_ADDON_URI
    url = process.env.MONGODB_ADDON_URI
else
    url =(process.env.MONGODB_URL || 'mongodb://localhost/') + 'algoprog'

logger.info "Using mongo url #{url}"

( () ->
    await mongoose.connect(url, {useNewUrlParser: true, useUnifiedTopology:true, useCreateIndex: true })
)().then(() -> logger.info "Successfully connected to mongo")
    .catch((error) ->
        logger.error error
        process.exit(1)
    )

export default db = mongoose.connection
