import blockIf from './blockIf'

getBlockedData = (contestResults) ->
    if not contestResults?.registered
        return {needRegistration: true}

export default needRegistration = (cls) ->
    return blockIf(cls, getBlockedData)