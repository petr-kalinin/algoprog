import FindMistake from '../models/FindMistake'

DISTANCE_THRESHOLD = 10

distance = (s1, s2) ->
    if (not s1) or (not s2)
        return DISTANCE_THRESHOLD + 1
    d = new Array(s1.length + 1)
    for _, i in d
        d[i] = new Array(s2.length + 1)
    d[0][0] = 0
    for _, i in s1
        d[i+1][0] = i+1
    for _, j in s2
        d[0][j+1] = j+1
    for c1, i in s1
        for c2, j in s2
            d[i+1][j+1] = Math.min(d[i][j+1], d[i+1][j]) + 1
            cost = if c1 == c2 then 0 else 1
            d[i+1][j+1] = Math.min(d[i+1][j+1], d[i][j] + cost)
    return d[s1.length][s2.length]

export default processForFindMistake = (submits) ->
    submits.reverse()
    currentOk = undefined
    for submit in submits
        if submit.outcome in ["OK", "AC", "IG"]
            currentOk = submit
        else
            if not currentOk
                continue
            if submit.user != currentOk.user
                throw "Different users in processForFindMistake: #{submit.user} vs #{currentOk.user}"
            if submit.problem != currentOk.problem
                throw "Different users in processForFindMistake: #{submit.problem} vs #{currentOk.problem}"
            if distance(submit.sourceRaw, currentOk.sourceRaw) < DISTANCE_THRESHOLD
                id = submit._id + "::" + currentOk._id
                if not (await FindMistake.findById(id))
                    findMistake = new FindMistake
                            _id: id
                            source: submit.sourceRaw
                            submit: submit._id
                            correctSubmit: currentOk._id
                            user: submit.user
                            problem: submit.problem
                    await findMistake.upsert()
                currentOk = undefined
