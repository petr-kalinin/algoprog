React = require('react')
import fetch from 'isomorphic-fetch'

import { Grid } from 'react-bootstrap'
import Contest from '../components/Contest'
import callApi from '../lib/callApi'

class ContestPage extends React.Component
    constructor: (props) ->
        super(props)
        @state = props.data || window.__INITIAL_STATE__ || {}

    render:  () ->
        return
            <Grid fluid>
                {@state.contest && `<Contest {...this.state}/>`}
            </Grid>

    componentDidMount: ->
        @reload()

    componentWillUnmount: ->
        clearTimeout(@timeout)

    reload: ->
        data = await ContestPage.loadData(@props.match)
        @setState(data)

    reloadAndSetTimeout: ->
        try
            await @reload()
        catch
            console.log "Can't reload data"
        @timeout = setTimeout((() => @reloadAndSetTimeout()), 20000)

    @loadData: (match) ->
        contest = await callApi 'contest/' + match.params.id
        return
            contest: contest

export default ContestPage
