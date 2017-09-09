React = require('react')
import fetch from 'isomorphic-fetch'

import { Grid } from 'react-bootstrap'
import callApi from '../lib/callApi'

import Tree from '../components/Tree'
import Root from '../components/Root'

class RootPage extends React.Component
    constructor: (props) ->
        super(props)
        @state = props.data || window.__INITIAL_STATE__ || {}

    render:  () ->
        return
            <Grid fluid>
                <Root tree={@state.tree}/>
            </Grid>

    componentDidMount: ->
        @reload()

    reload: ->
        data = await MaterialPage.loadData(@props.match)
        @setState(data)

    @loadData: (match) ->
        tree = await callApi 'material/tree'
        return
            tree: tree

export default RootPage
