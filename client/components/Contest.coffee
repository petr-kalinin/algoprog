React = require('react')

import { ListGroup, ListGroupItem } from 'react-bootstrap'
import { Link } from 'react-router-dom'

ProblemLine = (props) ->
    href = "/problem/#{props.problem._id}"
    <ListGroupItem key={props.problem._id} onClick={window?.goto?(href)} href={href}>{props.problem.name}</ListGroupItem>

export default Contest = (props) ->
    <div>
        <h1>{props.contest.name}</h1>
        <ListGroup>
            {props.contest.problems.map((p) -> <ProblemLine problem={p}/>)}
        </ListGroup>
    </div>
