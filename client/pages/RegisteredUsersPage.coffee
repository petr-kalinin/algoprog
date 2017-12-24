React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import RegisteredUsers from '../components/RegisteredUsers'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class RegisteredUsersPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Пользователи", _id: "registeredUsers"},
            showNews: "hide",
            showTree: "hide"
        }
        `<Sceleton {...sceletonProps}><RegisteredUsers users={this.props.data}/></Sceleton>`

options =
    urls: () ->
        "data": "registeredUsers"

export default ConnectedComponent(RegisteredUsersPage, options)
