React = require('react')
moment = require('moment')

import { Badge, ListGroup, ListGroupItem } from 'react-bootstrap'
import { Link } from 'react-router-dom'

import getContestSystem from '../contestSystems/ContestSystemRegistry'
import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

import ContestHeader from './ContestHeader'

Contest = (props) ->
    contestSystem = getContestSystem(props.contest.contestSystemData.system)
    ContestElement = contestSystem.Contest()
    <div>
        <ContestHeader {props...} />
        <ContestElement contestSystem={contestSystem} {props...}/>
    </div>

options =
    urls: (props) ->
        contestResult: "contestResult/#{props.contest._id}/#{props.myUser._id}"
        contest: "contest/#{props.match.params.id}"

export default withMyUser(ConnectedComponent(Contest, options))