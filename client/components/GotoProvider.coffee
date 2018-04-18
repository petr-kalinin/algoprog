React = require('react')

import { withRouter } from 'react-router'

class GotoProvider extends React.Component
    componentDidMount: (prevProps) ->
        window.goto = (url) =>
            (e) =>
                if e
                    e.preventDefault()
                @props.history.push(url)
                return false

    render: ->
        this.props.children

export default withRouter(GotoProvider)
