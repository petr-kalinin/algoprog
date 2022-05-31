React = require('react')

import { connect } from 'react-redux'
import Button from 'react-bootstrap/lib/Button'
import withLang from '../lib/withLang'
import * as actions from '../redux/actions'

export LangSwitch = (props) ->
    return if props.lang == "ru"
                <Button onClick={()->props.switchLang("en")} title="English">
                    EN
                </Button>
           else 
                <Button onClick={()->props.switchLang("ru")} title="Русский">
                    RU
                </Button>

mapStateToProps = (state) ->
    return
        lang: state.lang

mapDispatchToProps = (dispatch, ownProps) ->
    return
        switchLang: (newLang) -> 
            dispatch(actions.switchLang(newLang))

export default connect(mapStateToProps, mapDispatchToProps)(LangSwitch)