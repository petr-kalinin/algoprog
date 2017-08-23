React = require('react')
import { Link } from 'react-router-dom'
import { ListGroup, ListGroupItem } from 'react-bootstrap'
import { withRouter } from 'react-router'

goToProblem = (m, history) ->
    () ->
        history.push("/material/" + m)

Contest = (props) ->
    <div>
        <h1>{props.material.title}</h1>
        <ListGroup>
            {
            res = []
            a = (el) -> res.push(el)
            for m in props.material.materials
                a <ListGroupItem key={m._id} onClick={goToProblem(m._id, props.history)}>{m.title}</ListGroupItem>
            res}
        </ListGroup>
    </div>

export default withRouter(Contest)
