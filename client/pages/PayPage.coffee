React = require('react')

import { Helmet } from "react-helmet"

import Pay from '../components/Pay'
import Sceleton from '../components/Sceleton'

import ConnectedComponent from './ConnectedComponent'

class PayPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {@props..., location: {title: "Об оплате за занятия", _id: "pay"}}
        `<Sceleton {...sceletonProps}><Pay {...this.props}/></Sceleton>`

export default ConnectedComponent(PayPage)
