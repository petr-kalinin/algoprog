request = require('request-promise-native')

import logger from '../log'
import sleep from './sleep'

statistics =
    ok: 0
    fail: 0

STATS_MULTIPLIER = 1 - 1.0/100

isDev = !process.env.NODE_ENV || process.env.NODE_ENV == 'development'
mode = if isDev then "dev" else "clone"
USER_AGENT = process.env.USER_AGENT || "algoprog.ru [#{mode}]"
console.log "User-Agent=", USER_AGENT

addStats = (type) ->
    for t of statistics
        statistics[t] *= STATS_MULTIPLIER
    statistics[type] += 1

export getStats = () ->
    return statistics

export default download = (href, jar, options={}) ->
    logger.info "Downloading", href
    if not jar
        jar = request.jar()
    delay = 5
    maxAttempts = options?.maxAttempts || 1
    options.headers = options.headers || {}
    options.headers["User-Agent"] = USER_AGENT
    for i in [1..maxAttempts]
        try
            page = await request({
                options...,
                url: href
                jar: jar,
                gzip: true,
                timeout: options?.timeout || 7 * 1000
            })
            addStats("ok")
            return page
        catch e
            logger.info "Error downloading " + href + " " + i + " will re-download", e.message, delay
            #logger.info e.stack
            await sleep(delay)
            delay *= 2
    addStats("fail")
    throw "Can't download " + href

requests = 0
promises = []
REQUESTS_LIMIT = 10
export downloadLimited = (href, jar, options) ->
        if requests >= REQUESTS_LIMIT
            await new Promise((resolve) => promises.push(resolve))
        if requests >= REQUESTS_LIMIT
            throw "Too many requests"
        requests++
        try
            result = await download(href, jar, options)
        finally
            requests--
            if promises.length
                promise = promises.shift()
                promise(0)  # resolve
        return result
