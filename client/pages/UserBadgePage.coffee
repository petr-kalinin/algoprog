React = require('react')

import { Grid } from 'react-bootstrap'
import UserBadge from '../components/UserBadge'
import callApi from '../lib/callApi'

class UserBadgePage extends React.Component 
    constructor: (props) ->
        super(props)
        @id = UserBadgePage.getId(props.match)
        @state = props.data || window?.__INITIAL_STATE__ || {}
        @handleReload = @handleReload.bind(this)
        
    render:  () ->
        if not @state?.user.name
            return
                <Grid fluid>
                </Grid>
        return 
            <Grid fluid>
                <UserBadge user={@state.user} me={@state.me} handleReload={@handleReload}/>
            </Grid>
            
    componentDidMount: ->
        @handleReload()
        
    handleReload: ->
        data = await UserBadgePage.loadData(@props.match)
        @setState(data)
        
    @getId: (match) ->
        match.params.id
            
    @loadData: (match) ->
        user = await callApi 'user/' + UserBadgePage.getId(match)
        me = await callApi 'me'
        return
            user: user
            me: me

export default UserBadgePage 
