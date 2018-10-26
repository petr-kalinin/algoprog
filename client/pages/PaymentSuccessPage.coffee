React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import PaymentSuccess from '../components/PaymentSuccess'

export default class PaymentSuccessPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        <PaymentSuccess/>

