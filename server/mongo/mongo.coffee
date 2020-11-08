mongoose = require('mongoose')
import logger from '../log'

mongoose.Promise = global.Promise;

if process.env.MONGODB_HOST
    url = "mongodb://#{process.env.MONGO_USER}:#{process.env.MONGO_PASSWORD}@#{process.env.MONGODB_HOST}/algoprog"
else
    url = process.env.MONGODB_ADDON_URI || (
        (process.env.MONGODB_URL || 'mongodb://localhost/') + 'algoprog'
    )

( () ->
    await mongoose.connect(url, {useNewUrlParser: true, useUnifiedTopology:true, useCreateIndex: true })
)().catch((error) ->
    logger.error error
    process.exit(1)
)

export default db = mongoose.connection
