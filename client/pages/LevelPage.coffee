React = require('react')
import fetch from 'isomorphic-fetch'

import { Grid } from 'react-bootstrap'
import Level from '../components/Level'
import callApi from '../lib/callApi'

class LevelPage extends React.Component
    constructor: (props) ->
        super(props)
        @state = props.data || window.__INITIAL_STATE__ || {}

    render:  () ->
        return
            <Grid fluid>
                {@state.level && `<Level {...this.state}/>`}
            </Grid>

    componentDidMount: ->
        @reload()

    componentWillUnmount: ->
        clearTimeout(@timeout)

    reload: ->
        data = await LevelPage.loadData(@props.match)
        @setState(data)

    reloadAndSetTimeout: ->
        try
            await @reload()
        catch
            console.log "Can't reload data"
        @timeout = setTimeout((() => @reloadAndSetTimeout()), 20000)

    @loadData: (match) ->
        level = await callApi 'level/' + match.params.level
        return
            level: level

export default LevelPage
