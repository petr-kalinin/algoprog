export default blockIf = (cls, shouldBlock) ->
    class MaybeBlocked extends cls
        isBlocked: (contestResults) ->
            console.log "isBlocked=", shouldBlock(contestResults)
            return shouldBlock(contestResults)