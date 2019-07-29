mongoose = require('mongoose')
import logger from '../log'

mongoose.Promise = global.Promise;

url = process.env.MONGODB_ADDON_URI || (
    (process.env.MONGODB_URL || 'mongodb://localhost/') + 'algoprog_adina'
)

( () ->
    await mongoose.connect(url)
)().catch((error) ->
    logger.error error
    process.exit(1)
)

export default db = mongoose.connection
