export default blockIf = (cls, condition) ->
    class MaybeBlocked extends cls
        blockSubmit: (contestResults) ->
            return condition(contestResults)