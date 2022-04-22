React = require('react')
FontAwesome = require('react-fontawesome')

import { connect } from 'react-redux'
import Button from 'react-bootstrap/lib/Button'
import withTheme from '../lib/withTheme'
import * as actions from '../redux/actions'

export ThemeSwitch = (props) ->
    return if props.theme == "dark"
                <Button onClick={()->props.switchTheme("light")} title="Светлая тема">
                        <FontAwesome name="sun-o"/>&#8203;
                </Button>
           else 
                <Button onClick={()->props.switchTheme("dark")} title="Темная тема">
                    <FontAwesome name="moon-o"/>&#8203;
                </Button>

mapStateToProps = (state) ->
    return
        theme: state.theme

mapDispatchToProps = (dispatch, ownProps) ->
    return
        switchTheme: (newTheme) -> dispatch(actions.switchTheme(newTheme))

export default connect(mapStateToProps, mapDispatchToProps)(ThemeSwitch)