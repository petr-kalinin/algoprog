React = require('react')
FontAwesome = require('react-fontawesome')

import { connect } from 'react-redux'
import Button from 'react-bootstrap/lib/Button'

import{LangRaw} from '../lang/lang'
import withLang from '../lib/withLang'
import withTheme from '../lib/withTheme'
import * as actions from '../redux/actions'

export ThemeSwitch = withLang (props) ->
    return if props.theme == "dark"
                <Button onClick={()->props.switchTheme("light")} title={LangRaw("light_theme", props.lang)}>
                        <FontAwesome name="sun-o"/>&#8203;
                </Button>
           else 
                <Button onClick={()->props.switchTheme("dark")} title={LangRaw("dark_theme", props.lang)}>
                    <FontAwesome name="moon-o"/>&#8203;
                </Button>

mapStateToProps = (state) ->
    return
        theme: state.theme

mapDispatchToProps = (dispatch, ownProps) ->
    return
        switchTheme: (newTheme) -> dispatch(actions.switchTheme(newTheme))

export default connect(mapStateToProps, mapDispatchToProps)(ThemeSwitch)