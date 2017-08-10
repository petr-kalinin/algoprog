React = require('react')

import { Grid } from 'react-bootstrap'
import Table from '../components/Table'
import callApi from '../lib/callApi'

class TablePage extends React.Component 
    constructor: (props) ->
        super(props)
        @id = props.match.id
        @userList = props.match.userList
        @state = props.data || window?.__INITIAL_STATE__ || {}
        @handleReload = @handleReload.bind(this)
        
    render:  () ->
        return 
            <Grid fluid>
                <Table details={true} data={@state.data} me={@state.me} headerText={true} handleReload={@handleReload}/>
            </Grid>
            
    componentDidMount: ->
        @handleReload()
        
    handleReload: ->
        data = await TablePage.loadData(@props.match)
        @setState(data)
            
    @loadData: (match) ->
        data = await callApi 'table/' + match.params.userList + '/' + match.params.id
        me = await callApi 'me'
        return
            data: data
            me: me

export default TablePage 
