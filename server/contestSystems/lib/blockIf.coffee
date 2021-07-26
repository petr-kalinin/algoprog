export default blockIf = (cls, getBlockedDataImpl, blockSubmitImpl) ->
    class MaybeBlocked extends cls
        getBlockedData: (contestResults) ->
            data = getBlockedDataImpl?(contestResults) || {}
            return {data..., super(contestResults)...}

        shouldBlockSubmit: (contest, contestResults) ->
            return blockSubmitImpl?(contest, contestResults) || super(contest, contestResults)
