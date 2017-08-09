React = require('react')

import { Grid } from 'react-bootstrap'
import User from '../components/User'
import callApi from '../lib/callApi'

class UserPage extends React.Component 
    constructor: (props) ->
        super(props)
        @id = props.match.params.id
        @state = props.data || window?.__INITIAL_STATE__ || {}
        @handleReload = @handleReload.bind(this)
        
    render:  () ->
        if not @state?.user.name
            return
                <Grid fluid>
                </Grid>
        return 
            <Grid fluid>
                <User user={@state.user} me={@state.me} handleReload={@handleReload}/>
            </Grid>
            
    componentDidMount: ->
        @handleReload()
        
    handleReload: ->
        data = await UserPage.loadData(@props.match)
        @setState(data)
        
    @loadData: (match) ->
        user = await callApi 'user/' + match.params.id
        me = await callApi 'me'
        return
            user: user
            me: me

export default UserPage 
