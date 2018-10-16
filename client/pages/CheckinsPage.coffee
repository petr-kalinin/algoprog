React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import Checkins from '../components/Checkins'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class CheckinsPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Регистрация на занятие", _id: "checkins"},
        }
        `<Sceleton {...sceletonProps}><Checkins data={this.props.data} myUser={this.props.myUser} handleReload={this.props.handleReload}/></Sceleton>`

options =
    urls: () ->
        data: "checkins"
        myUser: "myUser"

    timeout: 20000

export default ConnectedComponent(CheckinsPage, options)
