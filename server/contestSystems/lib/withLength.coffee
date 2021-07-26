import blockIf from './blockIf'

blockSubmit = (contest, contestResults) ->
    if not contest.length
        return false
    passed = new Date() - contestResults.startTime
    return passed > contest.length

export default needRegistration = (cls) ->
    return blockIf(cls, undefined, blockSubmit)