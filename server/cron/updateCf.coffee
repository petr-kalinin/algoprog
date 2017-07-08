import User from '../models/user'

export default run = ->
    for u in await User.findAll()
        await u.updateCfRating()
