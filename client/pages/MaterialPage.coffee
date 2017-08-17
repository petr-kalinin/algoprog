React = require('react')
import fetch from 'isomorphic-fetch'

import { Grid } from 'react-bootstrap'
import Material from '../components/Material'
import callApi from '../lib/callApi'

class MaterialPage extends React.Component
    constructor: (props) ->
        super(props)
        @state = props.data || window.__INITIAL_STATE__ || {}

    render:  () ->
        return
            <Grid fluid>
                {@state.material && `<Material {...this.state}/>`}
            </Grid>

    componentDidMount: ->
        @reload()

    componentWillUnmount: ->
        clearTimeout(@timeout)

    reload: ->
        data = await MaterialPage.loadData(@props.match)
        @setState(data)

    reloadAndSetTimeout: ->
        try
            await @reload()
        catch
            console.log "Can't reload data"
        @timeout = setTimeout((() => @reloadAndSetTimeout()), 20000)

    @loadData: (match) ->
        material = await callApi 'material/' + match.params.id
        return
            material: material

export default MaterialPage
