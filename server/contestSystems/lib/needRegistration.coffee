import blockIf from './blockIf'

shouldBlock = (contestResults) ->
    return not contestResults?.registered

export default needRegistration = (cls) ->
    return blockIf(cls, shouldBlock)