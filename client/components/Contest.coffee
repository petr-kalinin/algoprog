React = require('react')

import { Badge, ListGroup, ListGroupItem } from 'react-bootstrap'
import { Link } from 'react-router-dom'

import getContestSystem from '../contestSystems/ContestSystemRegistry'
import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

Contest = (props) ->
    contestSystem = getContestSystem(props.contest.contestSystemData.system)
    ContestElement = contestSystem.Contest()
    <div>
        <h1>{props.contest.name}</h1>
        <ContestElement contestSystem={contestSystem} contest={props.contest} contestResult={props.contestResult} handleReload={props.handleReload}/>
    </div>

options =
    urls: (props) ->
        contestResult: "contestResult/#{props.contest._id}/#{props.myUser._id}"
        contest: "contest/#{props.match.params.id}"

export default withMyUser(ConnectedComponent(Contest, options))