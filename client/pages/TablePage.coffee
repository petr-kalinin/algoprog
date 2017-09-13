React = require('react')

import { Grid } from 'react-bootstrap'
import Table from '../components/Table'

import ConnectedComponent from './ConnectedComponent'

class TablePage extends React.Component
    constructor: (props) ->
        super(props)
        @id = props.match.id
        @userList = props.match.userList

    @url: (params) ->
        'table/' + params.userList + '/' + params.id

    render:  () ->
        return
            <Grid fluid>
                <Table details={true} data={@props.data} me={@props.me} headerText={true}/>
            </Grid>

export default ConnectedComponent(TablePage)
