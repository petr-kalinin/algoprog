React = require('react')

import { Helmet } from "react-helmet"

import Pay from '../components/Pay'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class PayPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {@props..., location: {title: "Об оплате за занятия", _id: "pay"}}
        `<Sceleton {...sceletonProps}><Pay {...this.props}/></Sceleton>`

options =
    urls: (props) ->
        myUser: "myUser"

export default PayPageConnected = ConnectedComponent(PayPage, options)
