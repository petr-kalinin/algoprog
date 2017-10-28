import logger from '../log'
request = require('request-promise-native')

sleep = (milliseconds) ->
    return new Promise((resolve) -> setTimeout(resolve, milliseconds))

export default download = (href, jar, options) ->
    logger.debug "Downloading", href
    if not jar
        jar = request.jar()
    delay = 5
    for i in [1..10]
        try
            page = await request({
                options...,
                url: href
                jar: jar,
                gzip: true,
                timeout: options?.timeout || 7 * 1000
            })
            return page
        catch e
            logger.info "Error downloading " + href + " " + i + " will re-download"
            logger.info e.message
            await sleep(delay)
            delay *= 2
    throw "Can't download"
