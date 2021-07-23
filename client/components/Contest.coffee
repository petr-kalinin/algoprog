React = require('react')

import { Badge, ListGroup, ListGroupItem } from 'react-bootstrap'
import { Link } from 'react-router-dom'

import getContestSystem from '../contestSystems/ContestSystemRegistry'
import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

ProblemLine = (props) ->
    href = "/problem/#{props.problem._id}"
    badge = null
    style = null
    if props.result
        badge = props.contestSystem.problemBadge(props.result)
        if props.result.ps > 0
            badge = "?" + badge
        style = props.contestSystem.problemStyle(props.result)
    <ListGroupItem onClick={window?.goto?(href)} href={href} bsStyle={style}>
        {props.problem.name}
        {badge && <Badge>{badge}</Badge>}
    </ListGroupItem>

Contest = (props) ->
    contestSystem = getContestSystem(props.contest.contestSystemData.system)
    <div>
        <h1>{props.contest.name}</h1>
        <ListGroup>
            {props.contest.problems.map((p) -> <ProblemLine problem={p} key={p._id} contestSystem={contestSystem} result={props.contestResult?.problemResults?[p._id]}/>)}
        </ListGroup>
    </div>

options =
    urls: (props) ->
        contestResult: "contestResult/#{props.contest._id}/#{props.myUser._id}"

export default withMyUser(ConnectedComponent(Contest, options))