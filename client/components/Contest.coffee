React = require('react')
import { Link } from 'react-router-dom'
import { ListGroup, ListGroupItem } from 'react-bootstrap'
import { withRouter } from 'react-router'

Contest = (props) ->
    <div>
        <h1>{props.material.title}</h1>
        <ListGroup>
            {
            res = []
            a = (el) -> res.push(el)
            for m in props.material.materials
                href = "/material/" + m._id
                a <ListGroupItem key={m._id} onClick={window?.goto?(href)} href={href}>{m.title}</ListGroupItem>
            res}
        </ListGroup>
    </div>

export default withRouter(Contest)
