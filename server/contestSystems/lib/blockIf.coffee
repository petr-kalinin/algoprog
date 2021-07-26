export default blockIf = (cls, getBlockedDataImpl) ->
    class MaybeBlocked extends cls
        getBlockedData: (contestResults) ->
            return getBlockedDataImpl(contestResults)