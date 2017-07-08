mongoose = require('mongoose')
import logger from '../log'

mongoose.Promise = global.Promise;

( () ->
    await mongoose.connect 'mongodb://localhost/algoprog'
)().catch((error) -> 
    logger.error error
    process.exit(1)
)

export default db = mongoose.connection
