React = require('react')

export default blockIf = (cls, condition, message) ->
    class MaybeBlocked extends cls
        Contest: (props) ->
            if not condition(props.contestResult)
                <div>{message}</div>
            else
                super props