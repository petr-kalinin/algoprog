import blockIf from './blockIf'

shouldBlock = (contestResults) ->
    return not contestResults?.startTime

export default needRegistration = (cls) ->
    return blockIf(cls, shouldBlock)