React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import SolvedByWeek from '../components/SolvedByWeek'
import ConnectedComponent from './ConnectedComponent'

class SolvedByWeekPage extends React.Component
    constructor: (props) ->
        super(props)
        @userList = props.match.params.userList

    @url: (params) ->
        'users/' + params.userList

    render:  () ->
        return
            <Grid fluid>
                <Helmet>
                    <title>Сданные задачи по неделям</title>
                </Helmet>
                <SolvedByWeek userList={@userList} users={@props.data} me={@props.me} details={true}/>
            </Grid>

export default ConnectedComponent(SolvedByWeekPage)
