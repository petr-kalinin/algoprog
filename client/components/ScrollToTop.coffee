React = require('react')

import { withRouter } from 'react-router'

class ScrollToTop extends React.Component
    componentDidUpdate: (prevProps) ->
        if @props.location != prevProps.location
            window.scrollTo(0, 0)

    render: ->
        this.props.children

export default withRouter(ScrollToTop)
