React = require('react')

import Grid from 'react-bootstrap/lib/Grid'

import Lang from '../lang/lang'

class PaymentSuccess extends React.Component
    constructor: (props) ->
        super(props)

    render: () ->
        <Grid>
            {Lang("payment_successful_message")}
        </Grid>

export default PaymentSuccess