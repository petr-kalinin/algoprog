os = require('os')

import {GROUPS} from '../../client/lib/informaticsGroups'

import {START_SUBMITS_DATE} from '../api/dashboard'

import send from '../metrics/graphite'
import notify from '../metrics/notify'

import FindMistake from '../models/FindMistake'
import Result from "../models/result"

import {mongoCallbacksCount} from '../mongo/MongooseCallbackManager'

sendGraphite = () ->
    queries = 
        ok: {ok: 1, lastSubmitTime: {$gt: START_SUBMITS_DATE}, findMistake: null, activated: true},
        ps: {ps: 1}
    metrics = {}
    for key, query of queries
        query.total = 1
        for group, _ of GROUPS
            query["userList"] = group
            metrics["#{key}.#{group}"] = (await Result.find(query)).length
    await send(metrics)

sendWebSocketsCount2Graphite = () ->
    metrics = {"websockets": mongoCallbacksCount()}
    await send(metrics)

sendPendingFindMistakes = () ->
    metrics = {"pendingFindMistakes": await FindMistake.findNotApprovedCount()}
    await send(metrics)

sendWarnings = () ->
    endDate = new Date(new Date() - 5 * 60 * 1000)
    query = {ps: 1, lastSubmitTime: {$lt: endDate}, total: 1}
    submits = await Result.find(query) 
    count = submits.length
    if count > 0
        notify "#{count} решений в статусе PS"

sendLoadAndMem = () ->
    await send
        "load5": os.loadavg()[1]
        "freemem": os.freemem()
        "totalmem": os.totalmem()

export default sendMetrics = () ->
    await sendWarnings()
    await sendGraphite()
    await sendWebSocketsCount2Graphite()
    await sendPendingFindMistakes() 
    await sendLoadAndMem()
