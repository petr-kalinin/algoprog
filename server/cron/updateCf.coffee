import User from '../models/user'

running = false

wrapRunning = (callable) ->
    () ->
        if running
            console.log "Already running updateCf"
            return
        try
            running = true
            await callable()
        finally
            running = false

export default run = wrapRunning ->
    for u in await User.findAll()
        await u.updateCfRating()
