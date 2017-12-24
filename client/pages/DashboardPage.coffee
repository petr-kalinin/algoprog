React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import Dashboard from '../components/Dashboard'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class DashboardPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Последние посылки", _id: "dashboard"},
            showNews: "hide",
            showTree: "hide"
        }
        `<Sceleton {...sceletonProps}><Dashboard {...this.props.data}/></Sceleton>`

options =
    urls: () ->
        data: "dashboard"

    timeout: 20000

export default ConnectedComponent(DashboardPage, options)
