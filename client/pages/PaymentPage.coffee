React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import Payment from '../components/Payment'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class PaymentPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Оплата занятий", _id: "payment"},
        }
        `<Sceleton {...sceletonProps}><Payment myUser={this.props.myUser} me={this.props.me}/></Sceleton>`

options =
    urls: () ->
        myUser: "myUser"
        me: "me"

    timeout: 20000

export default ConnectedComponent(PaymentPage, options)
