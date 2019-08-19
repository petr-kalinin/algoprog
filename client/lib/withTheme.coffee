React = require('react')
import { connect } from 'react-redux'

mapStateToProps = (state) ->
    return
        theme: state.theme

export default withTheme = (Component) -> connect(mapStateToProps)(Component)