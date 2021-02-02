React = require('react')

import Grid from 'react-bootstrap/lib/Grid'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

class PaymentSuccess extends React.Component
    constructor: (props) ->
        super(props)

    render: () ->
        <Grid>
            <h1>Оплата успешна</h1>
            <p>Оплата занятий успешна, срок занятий на сайте будет продлен в ближайшее время после обработки платежа.
            Обычно обработка занимает несколько секунд, в особых случаях может продолжаться несколько часов.
            Если через два часа срок оплаченных занятий не будет продлен, свяжитесь со мной.</p>

            <p>Чек об оплате (в соответствии с законом о самозанятых; чек может появиться не сразу, а через 20-30 секунд):</p>
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