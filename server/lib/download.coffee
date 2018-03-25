request = require('request-promise-native')

import logger from '../log'
import sleep from './sleep'

export default download = (href, jar, options) ->
    logger.debug "Downloading", href
    if not jar
        jar = request.jar()
    delay = 5
    maxAttempts = options?.maxAttempts || 8
    for i in [1..maxAttempts]
        try
            _debug_marker = {qwe: '221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221_221'}
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
            _debug_marker = {qwe: '222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222_222'}
            await sleep(delay)
            delay *= 2
    throw "Can't download"
