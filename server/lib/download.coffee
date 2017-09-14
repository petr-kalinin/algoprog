import logger from '../log'
request = require('request-promise-native')

export default download = (href, jar, options) ->
    if not jar
        jar = request.jar()
    for i in [1..10]
        try
            page = await request({
                options...,
                url: href
                jar: jar
            })
            return page
        catch e
            console.log e
            logger.info "Error downloading " + href + " " + i + " will re-download"
    throw "Can't download"
