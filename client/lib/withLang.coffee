React = require('react')
import { connect } from 'react-redux'

mapStateToProps = (state) ->
    return
        lang: state.lang

export default withLang = (Component) -> connect(mapStateToProps)(Component)