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
                a <ListGroupItem key={m._id} onClick={goToProblem(m._id, props.history)}>{m.title}</ListGroupItem>
            res}
        </ListGroup>
    </div>

export default withRouter(Contest)
