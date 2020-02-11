React = require('react')

import { withRouter } from 'react-router'

class YaMetrikaHit extends React.Component
    componentDidUpdate: (prevProps) ->
        if @props.location != prevProps.location and window.yaCounter45895896
            window.yaCounter45895896.hit?(@props.location.pathname)

    render: ->
        this.props.children

export default withRouter(YaMetrikaHit)
