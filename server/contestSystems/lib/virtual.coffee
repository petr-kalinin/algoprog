import blockIf from './blockIf'

getBlockedData = (contestResults) ->
    if not contestResults?.startTime
        return {virtualBlocked: true}

export default needRegistration = (cls) ->
    return blockIf(cls, getBlockedData)