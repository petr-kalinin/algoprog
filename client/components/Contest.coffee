React = require('react')
import { Link } from 'react-router-dom'
import { ListGroup, ListGroupItem } from 'react-bootstrap'
import { withRouter } from 'react-router'

goToProblem = (m, history) ->
    () ->
        history.push("/problem/" + m)

Contest = (props) ->
    <div>
        <h1>{props.contest.title}</h1>
        <ListGroup>
            {
            res = []
            a = (el) -> res.push(el)
            for m in props.contest.materials
                a <ListGroupItem key={m} onClick={goToProblem(m, props.history)}>Problem {m}</ListGroupItem>
            res}
        </ListGroup>
    </div>

export default withRouter(Contest)
