React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import SolvedByWeek from '../components/SolvedByWeek'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class SolvedByWeekPage extends React.Component
    constructor: (props) ->
        super(props)
        @userList = props.match.params.userList

    @urls: (props) ->
        data: "users/#{props.match.params.userList}"
        me: "me"

    @timeout: () ->
        20000

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Сданные задачи по неделям", _id: "table:#{@userList}:byWeek"},
            showNews: "hide",
            showTree: "hide"
        }
        child = <SolvedByWeek userList={@userList} users={@props.data} me={@props.me} details={true}/>
        `<Sceleton {...sceletonProps}>{child}</Sceleton>`

export default ConnectedComponent(SolvedByWeekPage)
