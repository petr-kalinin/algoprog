React = require('react')

import { Grid } from 'react-bootstrap'
import Table from '../components/Table'
import Sceleton from '../components/Sceleton'

import ConnectedComponent from './ConnectedComponent'

class TablePage extends React.Component
    constructor: (props) ->
        super(props)
        @id = props.match.params.id
        @userList = props.match.params.userList

    @url: (params) ->
        'table/' + params.userList + '/' + params.id

    render:  () ->
        sceletonProps = {
            @props...,
            location: {_id: "table:#{@userList}:#{@id}"},
            showNews: "hide",
            showTree: "hide"
        }
        child = <Table details={true} data={@props.data} me={@props.me} headerText={true}/>
        `<Sceleton {...sceletonProps}>{child}</Sceleton>`

export default ConnectedComponent(TablePage)
