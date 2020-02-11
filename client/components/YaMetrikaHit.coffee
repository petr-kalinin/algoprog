React = require('react')

import { withRouter } from 'react-router'

class YaMetrikaHit extends React.Component
    componentDidUpdate: (prevProps) ->
        if @props.location != prevProps.location and window.yaCounter54702844
            window.yaCounter54702844.hit?(@props.location.pathname)

    render: ->
        this.props.children

export default withRouter(YaMetrikaHit)
