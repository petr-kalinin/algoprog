
React = require('react')
FontAwesome = require('react-fontawesome')

import { connect } from 'react-redux'
import Button from 'react-bootstrap/lib/Button'
import * as actions from '../redux/actions'

export ThemeSwitch = (props) ->
    return <Button onClick={props.themeswitch}>
                <FontAwesome name="sun-o"/>
            </Button>

mapStateToProps = (state) ->
    return
        themeswitch: state.themeswitch

mapDispatchToProps = (dispatch, ownProps) ->
    return
        themeswitch: () -> dispatch(actions.themeswitch())

export default connect(mapStateToProps, mapDispatchToProps)(ThemeSwitch)