
React = require('react')
FontAwesome = require('react-fontawesome')

import { connect } from 'react-redux'
import Button from 'react-bootstrap/lib/Button'
import * as actions from '../redux/actions'

export ThemeSwitch = (props) ->
    return if props.theme == "light"
                <span title="Светлая тема">
                    <Button onClick={()->props.themeswitch("dark")}>
                            <FontAwesome name="sun-o"/>
                    </Button>
                </span>
           else 
                <span title="Темная тема">
                    <Button onClick={()->props.themeswitch("light")}>
                        <FontAwesome name="moon-o"/>
                    </Button>
                </span>

mapStateToProps = (state) ->
    return
        theme: state.theme

mapDispatchToProps = (dispatch, ownProps) ->
    return
        themeswitch: (Switch) -> dispatch(actions.themeswitch(Switch))

export default connect(mapStateToProps, mapDispatchToProps)(ThemeSwitch)