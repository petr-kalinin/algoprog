mongoose = require('mongoose')

mongoose.Promise = global.Promise;

( () ->
    await mongoose.connect 'mongodb://localhost/algoprog'
)().catch((error) -> 
    console.log error
    process.exit(1)
)

export default db = mongoose.connection
