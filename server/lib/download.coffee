request = require('request-promise-native')

export default download = (href, jar) ->
    if not jar
        jar = request.jar()
    for i in [1..10]
        try
            page = await request
                url: href
                jar: jar
            return page
        catch
            logger.info "Error downloading " + href + " " + i + " will re-download"
