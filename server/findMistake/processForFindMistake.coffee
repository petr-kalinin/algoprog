import {DISTANCE_THRESHOLD, distance} from '../../client/lib/findMistake'

import FindMistake from '../models/FindMistake'
import Problem from '../models/problem'

export default processForFindMistake = (submits) ->
    submits.reverse()
    currentOk = undefined
    for submit in submits
        if submit.findMistake
            continue
        if submit.outcome in ["OK", "AC", "IG"]
            currentOk = submit
        else
            if not currentOk
                continue
            if submit.user != currentOk.user
                throw "Different users in processForFindMistake: #{submit.user} vs #{currentOk.user}"
            if submit.problem != currentOk.problem
                throw "Different users in processForFindMistake: #{submit.problem} vs #{currentOk.problem}"
            if distance(submit.sourceRaw, currentOk.sourceRaw) < DISTANCE_THRESHOLD and submit.language == currentOk.language
                problem = await Problem.findById(submit.problem)
                if not problem
                    continue
                id = submit._id + "::" + currentOk._id
                findMistake = new FindMistake
                        _id: id
                        source: submit.sourceRaw
                        submit: submit._id
                        correctSubmit: currentOk._id
                        user: submit.user
                        problem: submit.problem
                        language: submit.language
                        order: problem.order
                oldData = await FindMistake.findById(id)
                if oldData
                    findMistake.approved = oldData.approved
                await findMistake.upsert()
                currentOk = undefined
