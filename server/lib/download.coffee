import logger from '../log'
request = require('request-promise-native')

sleep = (milliseconds) ->
    return new Promise((resolve) -> setTimeout(resolve, milliseconds))

export default download = (href, jar, options) ->
    if not jar
        jar = request.jar()
    delay = 5
    for i in [1..10]
        try
            page = await request({
                options...,
                url: href
                jar: jar,
                timeout: options?.timeout || 7 * 1000
            })
            return page
        catch e
            console.log e.message
            logger.info "Error downloading " + href + " " + i + " will re-download"
            await sleep(delay)
            delay *= 2
    throw "Can't download"
