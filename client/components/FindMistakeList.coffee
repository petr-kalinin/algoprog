React = require('react')
moment = require('moment')

import { ListGroup, ListGroupItem } from 'react-bootstrap'
import {Link} from 'react-router-dom'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

getClass = (result) ->
    if not result
        return undefined    
    switch
        when result.solved > 0 then "success"
        when result.ok > 0 then "success"
        when result.ignored > 0 then "info"
        when result.attempts > 0 then "danger"
        else undefined

FindMistakeList = (props) ->
    <ListGroup>
        {props.findMistakes.map (m) ->
            href = "/findMistake/" + m._id
            cl = getClass(props.results?[m._id])
            <ListGroupItem key={m._id} onClick={window?.goto?(href)} href={href} bsStyle={cl}>
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
            results: "userResultsForFindMistake/#{props.myUser?._id}"

export default withMyUser(ConnectedComponent(FindMistakeList, options))
