import {GROUPS} from '../../client/lib/informaticsGroups'
import {START_SUBMITS_DATE} from '../api/dashboard'
import send from '../metrics/graphite'
import Result from "../models/result"

export default sendMetrics = () ->
    queries = 
        ok: {ok: 1, lastSubmitTime: {$gt: START_SUBMITS_DATE}},
        ps: {ps: 1}
    metrics = {}
    for key, query of queries
        for group, _ of GROUPS
            query["userList"] = group
            metrics["#{key}.#{group}"] = (await Result.find(query)).length
    await send(metrics)