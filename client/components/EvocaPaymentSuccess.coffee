React = require('react')
import { withRouter } from 'react-router'

import Grid from 'react-bootstrap/lib/Grid'

import Lang from '../lang/lang'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

getOrderId = (location) ->
    return (new URLSearchParams(location.search)).get("orderId") || ""


class EvocaPaymentSuccess extends React.Component
    constructor: (props) ->
        super(props)

    render: () ->
        <Grid>
            {if @props.status.status
                <>
                    {Lang("payment_successful_message")}
                    <img src={@props.recentReceipt?.receipt} />
                </>
             else
                <>
                    {Lang("payment_error")}
                </>
            }
        </Grid>

options =
    urls: (props) ->
        if props?.myUser?._id
            return
                status: "evocaStatus/" + getOrderId(props.location)
                recentReceipt: "recentReceipt/#{props.myUser._id}"
        return {}

    timeout: 20 * 1000

export default withRouter(withMyUser(ConnectedComponent(EvocaPaymentSuccess, options)))