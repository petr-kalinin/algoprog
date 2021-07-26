React = require('react')

Header = (props) ->
    props.contestResult.needRegistration && <div>Вы не зарегистрированы на контест</div> || null

export default needRegistration = (cls) ->
    return class WithNeedRegistrationHeader extends cls
        Contest: () ->
            Super = super()
            (props) ->
                <div>
                    <Header {props...}/>
                    <Super {props...}/>
                </div>