React = require('react')

import blockIf from './blockIf'

shouldBlock = (contestResults) ->
    return not contestResults?.registered

Message = (props) ->
    <div>Вы не зарегистрированы на контест</div>

export default needRegistration = (cls) ->
    return blockIf(cls, shouldBlock, Message)