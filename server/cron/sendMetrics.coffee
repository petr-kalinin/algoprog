import {GROUPS} from '../../client/lib/informaticsGroups'
import {START_SUBMITS_DATE} from '../api/dashboard'
import send from '../metrics/graphite'
import notify from '../metrics/notify'
import Result from "../models/result"

sendGraphite = () ->
    queries = 
        ok: {ok: 1, lastSubmitTime: {$gt: START_SUBMITS_DATE}},
        ps: {ps: 1}
    metrics = {}
    for key, query of queries
        query["total"] = 1
        query.activated = true
        for group, _ of GROUPS
            query["userList"] = group
            metrics["#{key}.#{group}"] = (await Result.find(query)).length
    await send(metrics)

sendWarnings = () ->
    endDate = new Date(new Date() - 5 * 60 * 1000)
    query = {ps: 1, lastSubmitTime: {$lt: endDate}, total: 1}
    submits = await Result.find(query) 
    count = submits.length
    if count > 0
        notify "#{count} решений в статусе PS"


export default sendMetrics = () ->
    await sendWarnings()
    await sendGraphite()
