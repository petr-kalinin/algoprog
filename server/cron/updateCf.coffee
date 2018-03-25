import User from '../models/user'
import logger from '../log'
running = false

wrapRunning = (callable) ->
    () ->
        if running
            logger.info "Already running updateCf"
            return
        try
            running = true
            await callable()
        finally
            running = false

export default run = wrapRunning ->
    User.updateAllCf()
