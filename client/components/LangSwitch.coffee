React = require('react')

import { connect } from 'react-redux'
import Button from 'react-bootstrap/lib/Button'
import withLang from '../lib/withLang'
import * as actions from '../redux/actions'

import callApi from '../lib/callApi'

export LangSwitch = (props) -> 
    setInterfaceLanguage = (lang) ->
        () ->
            props.switchLang(lang)
            await callApi "setLang/#{lang}", {}
    
    return if props.lang == "ru"
                <Button onClick={ setInterfaceLanguage("en") } title="English">
                    EN
                </Button>
           else 
                <Button onClick={ setInterfaceLanguage("ru") } title="Русский">
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