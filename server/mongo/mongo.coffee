mongoose = require('mongoose')
import logger from '../log'

mongoose.Promise = global.Promise;

( () ->
    await mongoose.connect(process.env.OPENSHIFT_MONGODB_DB_URL || 'mongodb://localhost/algoprog')
)().catch((error) -> 
    logger.error error
    process.exit(1)
)

export default db = mongoose.connection
