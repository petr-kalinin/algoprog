React = require('react')

import { withRouter } from 'react-router'

class YaMetrikaHit extends React.Component
    componentDidUpdate: (prevProps) ->
        if @props.location != prevProps.location
            window.yaCounter45895896.hit(@props.location)

    render: ->
        this.props.children

export default withRouter(YaMetrikaHit)
