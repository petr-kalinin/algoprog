React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import Payment from '../components/Payment'
import Sceleton from '../components/Sceleton'

import {LangRaw} from '../lang/lang'
import ConnectedComponent from '../lib/ConnectedComponent'
import withLang from '../lib/withLang'

class PaymentPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: LangRaw("payment_for_the_course", @props.lang), _id: "payment"},
        }
        `<Sceleton {...sceletonProps}><Payment myUser={this.props.myUser} me={this.props.me}/></Sceleton>`

options =
    urls: () ->
        myUser: "myUser"
        me: "me"

    timeout: 20000

export default ConnectedComponent(withLang(PaymentPage), options)
