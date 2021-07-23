mongoose = require('mongoose')
import logger from '../log'

mongoose.Promise = global.Promise;

if process.env.MONGODB_HOST and process.env.MONGO_USER and process.env.MONGO_PASSWORD
    url = "mongodb://#{process.env.MONGO_USER}:#{process.env.MONGO_PASSWORD}@#{process.env.MONGODB_HOST}/algoprog_archive"
else
    url =(process.env.MONGODB_URL || 'mongodb://root:root@localhost/algoprog_archive?authSource=admin') 

if process.env.MONGODB_USERS_HOST and process.env.MONGO_USERS_USER and process.env.MONGO_USERS_PASSWORD
    usersUrl = "mongodb://#{process.env.MONGO_USERS_USER}:#{process.env.MONGO_USERS_PASSWORD}@#{process.env.MONGODB_USERS_HOST}/algoprog"
else
    usersUrl =(process.env.MONGODB_USERS_URL || 'mongodb://readonly:readonly@localhost/algoprog') 

logger.info "Using mongo url #{url} , users url #{usersUrl}"

usersConnection = mongoose.createConnection(usersUrl, {useNewUrlParser: true, useUnifiedTopology:true, useCreateIndex: true })

( () ->
    await mongoose.connect(url, {useNewUrlParser: true, useUnifiedTopology:true, useCreateIndex: true })
)().then(() -> logger.info "Successfully connected to mongo")
    .catch((error) ->
        logger.error error
        process.exit(1)
    )

export default db = mongoose.connection
export usersDb = usersConnection
