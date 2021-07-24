export default blockIf = (cls, shouldBlock) ->
    class MaybeBlocked extends cls
        isBlocked: (contestResults) ->
            return shouldBlock(contestResults)