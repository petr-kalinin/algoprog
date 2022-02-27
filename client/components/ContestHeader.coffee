React = require('react')
moment = require('moment')

import { LinkContainer } from 'react-router-bootstrap'

import { Button, ButtonGroup, Badge, ListGroup, ListGroupItem } from 'react-bootstrap'
import { Link } from 'react-router-dom'

import getContestSystem from '../contestSystems/ContestSystemRegistry'
import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

export default ContestHeader = (props) ->
    if props.contestResult.startTime
        passed = new Date() - new Date(props.contestResult.startTime)
        frozen = props.contest.freeze && passed < props.contest.length && passed > props.contest.freeze
    else
        passed = undefined
        frozen = undefined
    contestSystem = getContestSystem(props.contest.contestSystemData.system)
    <div>
        <h1>{props.contest.name}</h1>
        <div>
            {passed && <p>Прошло: {Math.round(passed / 60 / 1000)} минут  
                (время начала контеста: {moment(props.contestResult.startTime).format('DD.MM.YY HH:mm:ss')})</p>}
            {props.contest.length && <p>Длительность контеста: {Math.floor(props.contest.length / 1000 / 60)} минут</p>}
            {frozen && <p><b>Таблица заморожена</b></p>}
        </div>
        <ButtonGroup bsSize="small">
            {props.contest.problems.map((p) ->
                style = null
                result=props.contestResult?.problemResults?[p._id]
                if result
                    style = contestSystem.problemStyle(result)
                <LinkContainer to="/problem/#{props.contest._id}/#{p._id}" key={p._id}>
                    <Button title={p.name} bsStyle={style}>
                        {p.letter}
                    </Button>
                </LinkContainer>
            )}
            {props.contest.hasStatements && 
                <Button href="/api/contestStatements/#{props.contest._id}">
                    Условия в pdf
                </Button>
            }
            <LinkContainer to="/monitor/#{props.contest._id}">
                <Button>
                    Текущие результаты
                </Button>
            </LinkContainer>
        </ButtonGroup>
    </div>
