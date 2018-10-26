React = require('react')

import Grid from 'react-bootstrap/lib/Grid'

export default class PaymentSuccess extends React.Component
    constructor: (props) ->
        super(props)

    render: () ->
        <Grid>
            <h1>Оплата успешна</h1>
            <p>Оплата занятий успешна, срок занятий на сайте будет продлен в ближайшее время после обработки платежа.
            Обычно обработка занимает несколько секунд, в особых случаях может продолжаться несколко часов.
            Если через два часа срок оплаченных занятий не будет продлен, свяжитесь со мной.</p>
        </Grid>