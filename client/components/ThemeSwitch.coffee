React = require('react')
FontAwesome = require('react-fontawesome')

import { connect } from 'react-redux'
import Button from 'react-bootstrap/lib/Button'
import withTheme from '../lib/withTheme'
import * as actions from '../redux/actions'

export ThemeSwitch = (props) ->
    return if props.theme == "dark"
                <span title="Светлая тема">
                    <Button onClick={()->props.switchTheme("light")}>
                            <FontAwesome name="sun-o"/>
                    </Button>
                </span>
           else 
                <span title="Темная тема">
                    <Button onClick={()->props.switchTheme("dark")}>
                        <FontAwesome name="moon-o"/>
                    </Button>
                </span>

mapStateToProps = (state) ->
    return
        theme: state.theme

mapDispatchToProps = (dispatch, ownProps) ->
    return
        switchTheme: (newTheme) -> dispatch(actions.switchTheme(newTheme))

export default connect(mapStateToProps, mapDispatchToProps)(ThemeSwitch)