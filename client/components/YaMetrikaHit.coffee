React = require('react')

import { withRouter } from 'react-router'

class YaMetrikaHit extends React.Component
    componentDidUpdate: (prevProps) ->
        if @props.location != prevProps.location and window.yaCounter57483472
            window.yaCounter57483472.hit?(@props.location.pathname)

    render: ->
        this.props.children

export default withRouter(YaMetrikaHit)
