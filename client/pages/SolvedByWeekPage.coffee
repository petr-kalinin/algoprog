React = require('react')

import { Grid } from 'react-bootstrap'
import SolvedByWeek from '../components/SolvedByWeek'
import callApi from '../lib/callApi'

class SolvedByWeekPage extends React.Component 
    constructor: (props) ->
        super(props)
        @userList = props.match.params.userList
        @state = props.data || window?.__INITIAL_STATE__ || {}
        @handleReload = @handleReload.bind(this)
        
    render:  () ->
        return 
            <Grid fluid>
                <SolvedByWeek userList={@userList} users={@state.users} me={@state.me} handleReload={@handleReload} details={true}/>
            </Grid>
            
    componentDidMount: ->
        @handleReload()
        
    handleReload: ->
        data = await SolvedByWeekPage.loadData(@props.match)
        @setState(data)
            
    @loadData: (match) ->
        users = await callApi 'users/' + match.params.userList
        me = await callApi 'me'
        return
            users: users
            me: me

export default SolvedByWeekPage 
