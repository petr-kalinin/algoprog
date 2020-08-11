React = require('react')
moment = require('moment')

import { ListGroup, ListGroupItem } from 'react-bootstrap'
import {Link} from 'react-router-dom'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

FindMistakeList = (props) ->
    <ListGroup>
        {props.findMistakes.map (m) ->
            href = "/findMistake/" + m._id
            <ListGroupItem key={m._id} onClick={window?.goto?(href)} href={href}>
                {m.fullProblem.name}{" "} 
                ({m.fullProblem.level}, {m.language}){" "} 
                <small>#{m.hash}</small>
            </ListGroupItem>
        }
    </ListGroup>

options = 
    urls: (props) ->
        return
            findMistakes: "findMistakeList/#{props.myUser?._id}"

export default withMyUser(ConnectedComponent(FindMistakeList, options))
