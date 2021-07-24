React = require('react')

export default blockIf = (cls, shouldBlock, Message) ->
    class MaybeBlocked extends cls
        Contest: () ->
            Super = super()
            (props) ->
                if shouldBlock(props.contestResult)
                    `<Message {...props}/>`
                else
                    `<Super {...props}/>`