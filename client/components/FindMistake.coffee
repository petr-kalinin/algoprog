React = require('react')
moment = require('moment')

import { ListGroup, ListGroupItem } from 'react-bootstrap'
import {Link} from 'react-router-dom'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

FindMistake = (props) ->
    <pre>{props.findMistake?.source}</pre>

export default FindMistake
