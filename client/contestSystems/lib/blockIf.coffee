React = require('react')

export default blockIf = (cls, shouldBlock, message) ->
    class MaybeBlocked extends cls
        Contest: (props) ->
            if shouldBlock(props.contestResult)
                <div>{message}</div>
            else
                super props