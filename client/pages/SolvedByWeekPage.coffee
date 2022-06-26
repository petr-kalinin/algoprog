React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import SolvedByWeek from '../components/SolvedByWeek'
import Sceleton from '../components/Sceleton'

import {LangRaw} from '../lang/lang'
import ConnectedComponent from '../lib/ConnectedComponent'
import withLang from '../lib/withLang'

class SolvedByWeekPage extends React.Component
    constructor: (props) ->
        super(props)
        @userList = props.match.params.userList

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: LangRaw("solved_problems_by_week", @props.lang), _id: "table:#{@userList}:byWeek"},
            showNews: "hide",
            showTree: "hide"
        }
        child = <SolvedByWeek userList={@userList} users={@props.data} me={@props.me} details={true}/>
        `<Sceleton {...sceletonProps}>{child}</Sceleton>`

options =
    urls: (props) ->
        data: "users/#{props.match.params.userList}"
        me: "me"

    timeout: 20000

export default ConnectedComponent(withLang(SolvedByWeekPage), options)
