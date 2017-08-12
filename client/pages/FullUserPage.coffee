React = require('react')

import { Grid } from 'react-bootstrap'
import FullUser from '../components/FullUser'
import { CometSpinLoader } from 'react-css-loaders';

import callApi from '../lib/callApi'

export default class FullUserPage extends React.Component 
    constructor: (props) ->
        super(props)
        @id = props.match.params.id
        @state = props.data || window?.__INITIAL_STATE__ || {}
        @handleReload = @handleReload.bind(this)
        
    render:  () ->
        if not @state?.user?.name
            return
                <CometSpinLoader />
        return 
            <Grid fluid>
                <FullUser user={@state.user} me={@state.me} results={@state.results} handleReload={@handleReload}/>
            </Grid>
            
    componentDidMount: ->
        @handleReload()
        
    handleReload: ->
        data = await FullUserPage.loadData(@props.match)
        @setState(data)
        
    @loadData: (match) ->
        data = await callApi 'fullUser/' + match.params.id
        data.me = await callApi 'me'
        return data
