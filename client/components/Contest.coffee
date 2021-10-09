React = require('react')
moment = require('moment')

import { Badge, ListGroup, ListGroupItem } from 'react-bootstrap'
import { Link } from 'react-router-dom'

import getContestSystem from '../contestSystems/ContestSystemRegistry'
import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

export ContestInfo = (props) ->
    <div>
        {props.contestResult.startTime && <p>Прошло: {Math.round(moment.duration(moment().diff(props.contestResult.startTime)).asMinutes())} минут  
            (время начала контеста: {moment(props.contestResult.startTime).format('DD.MM.YY HH:mm:ss')})</p>}
        {props.contest.length && <p>Длительность контеста: {Math.floor(props.contest.length / 1000 / 60)} минут</p>}
    </div>

Header = (props) ->
    <div>
        <h1>{props.contest.name}</h1>
        <ContestInfo {props...}/>
        <p><Link to="/monitor/#{props.contest._id}">Текущие результаты</Link></p>
    </div>

Contest = (props) ->
    contestSystem = getContestSystem(props.contest.contestSystemData.system)
    ContestElement = contestSystem.Contest()
    <div>
        <Header {props...} />
        <ContestElement contestSystem={contestSystem} contest={props.contest} contestResult={props.contestResult} handleReload={props.handleReload}/>
    </div>

options =
    urls: (props) ->
        contestResult: "contestResult/#{props.contest._id}/#{props.myUser._id}"
        contest: "contest/#{props.match.params.id}"

export default withMyUser(ConnectedComponent(Contest, options))