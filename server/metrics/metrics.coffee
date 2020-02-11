import logger from '../log'
import send from './graphite'
responseTime = require('response-time')

logRequest = (req, res, time) ->
    logger.info "Request to ", req.path, " user ", req.user?.informaticsId, " time=", time

PERIOD = 300

times = {}
counts = {}
totalCounts = 0
totalTime = 0
lastAccumulateTime = new Date()

sendToGraphite = (passed) ->
    metrics = 
        "rps.all": totalCounts / (passed / 1000)
        "avg.all": totalTime / totalCounts
    #for path of times
    #    correctedPath = path.substr(1).replace("/", ".")
    #    metrics["rps._.#{correctedPath}"] = counts[path] / (passed / 1000)
    #    metrics["avg._.#{correctedPath}"] = times[path] / counts[path]
    send(metrics)

accumulateRequests = (req, rs, time) ->
    if not (req.path of times)
        times[req.path] = 0
    if not (req.path of counts)
        counts[req.path] = 0
    times[req.path] += time
    counts[req.path] += 1
    totalTime += time
    totalCounts += 1
    now = new Date()
    passed = now - lastAccumulateTime
    if passed > PERIOD * 1000
        logger.info "Request statistics for #{passed/1000} s: #{totalCounts} requests, #{totalTime} time, #{totalTime / totalCounts} avg"
        for path of times
            logger.info "Request statistics for #{passed/1000} s for path #{path}: #{counts[path]} requests, #{times[path]} time, #{times[path] / counts[path]} avg"
        sendToGraphite(passed)
        times = {}
        counts = {}
        totalTime = 0
        totalCounts = 0
        lastAccumulateTime = now

export default setupMetrics = (app) ->
    log = process.env["LOG_REQUESTS"]
    accumulate = process.env["ACCUMULATE_REQUESTS"]
    app.use(responseTime((req, res, time) ->
        if log then logRequest(req, res, time)
        if accumulate then accumulateRequests(req, res, time)
    ))
