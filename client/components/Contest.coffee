React = require('react')
import { Link } from 'react-router-dom'
import { ListGroup, ListGroupItem } from 'react-bootstrap'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyResults from '../lib/withMyResults'

getClass = (result) ->
    switch
        when result.solved > 0 then "success"
        when result.ok > 0 then "warning"
        when result.ignored > 0 then "info"
        when result.attempts > 0 then "danger"
        else undefined



Contest = (props) ->
    <div>
        <h1>{props.material?.title}</h1>
        <ListGroup>
            {
            res = []
            a = (el) -> res.push(el)
            for m in props.material.materials
                id = props.myUser?._id + "::" + m._id
                if props.myResults?[id]?
                    cl = getClass(props.myResults[id])
                else
                    cl = undefined
                href = "/material/" + m._id
                a <ListGroupItem key={m._id} onClick={window?.goto?(href)} href={href} bsStyle={cl}>{m?.title}</ListGroupItem>
            res}
        </ListGroup>
    </div>

export default withMyResults(Contest)
