React = require('react')

import Grid from 'react-bootstrap/lib/Grid'

import Lang from '../lang/lang'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

class PaymentSuccess extends React.Component
    constructor: (props) ->
        super(props)

    render: () ->
        <Grid>
            {Lang("payment_successful_message")}
            <img src={@props.recentReceipt?.receipt} />
        </Grid>

options =
    urls: (props) ->
        if props?.myUser?._id
            return
                recentReceipt: "recentReceipt/#{props.myUser._id}"
        return {}

    timeout: 20 * 1000

export default withMyUser(ConnectedComponent(PaymentSuccess, options))