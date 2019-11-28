import Hash from '../models/Hash'
import Submit from '../models/submit'

export default findSimilarSubmits = (submit, limit) ->
    candidates = []
    for h in submit.hashes
        otherHashes = await Hash.findByHashAndNotUser(h.hash, submit.user)
        candidates = candidates.concat(otherHashes)
    candidates.sort (a, b) ->
        scoreA = a.window * a.score
        scoreB = b.window * b.score
        if scoreB != scoreA 
            return scoreB - scoreA
        if a._id < b._id
            return 1
        else if a._id > b._id
            return -1
        else
            return 0
    result = []
    seenIds = {}
    for candidate in candidates
        if candidate.submit of seenIds
            continue
        seenIds[candidate.submit] = true
        submit = await Submit.findById(candidate.submit)
        result.push submit
        if result.length == limit
            break
    return result
