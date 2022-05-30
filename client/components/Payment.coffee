React = require('react')
moment = require('moment')

import Button from 'react-bootstrap/lib/Button'
import Alert from 'react-bootstrap/lib/Alert'
import { Link } from 'react-router-dom'

import {LangRaw} from '../lang/lang'

import GROUPS from '../lib/groups'
import withLang from '../lib/withLang'

import FieldGroup from './FieldGroup'

class Payment extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            name: ""
            email: ""
        @setField = @setField.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    pay: (e) ->
        console.log "try pay"
        form = document.getElementById("payForm")
        console.log form.terminalkey.value
        pay(form) 
        e.preventDefault()
        return false

    render: () ->
        canSubmit = true
        if not @props.myUser?._id
            amount = 1500
            warning = <Alert bsStyle="danger">
                    {LangRaw("cant_pay_not_registered", @props.lang)}
                </Alert>
            canSubmit = false
        else if not @props.myUser?.activated
            amount = 1500
            warning = <Alert bsStyle="danger">
                    {LangRaw("cant_pay_not_activated", @props.lang)}
                </Alert>
            canSubmit = false
        else if not GROUPS[@props.myUser.userList]?.paid or @props.myUser.price == 0
            amount = 0
            warning = <Alert bsStyle="danger">
                    {LangRaw("cant_pay_free", @props.lang)}
                </Alert>
            canSubmit = false
        else if not @props.myUser.price or not @props.myUser.paidTill
            amount = 1500
            warning = <Alert bsStyle="danger">
                    {LangRaw("cant_pay_no_price", @props.lang)}
                </Alert>
            canSubmit = false
        else 
            amount = @props.myUser.price
            warning = null

        receipt = 
            Taxation: "usn_income",
            Items: [ {
                Name: "Оплата занятий на algoprog.ru",
                Price: amount * 100,
                Quantity: 1.0,
                Amount: amount * 100,
                Tax: "none" 
            }]
        if @props.myUser?.paidTill
            paidTill = moment(@props.myUser.paidTill).utc().format("YYYYMMDD")
            order = "#{@props.myUser._id}:#{paidTill}"
        else
            order = ""

        canSubmit = canSubmit and @state.name and @state.email

        <div>
            <h1>{LangRaw("payment_for_the_course", @props.lang)}</h1>
            {warning}
            <p>{LangRaw("you_pay_for_one_month", @props.lang)(amount)}</p>
            <p><b>{LangRaw("payment_is_possible_only_from_russian_banks", @props.lang)}</b></p>
            <script src="https://securepay.tinkoff.ru/html/payForm/js/tinkoff_v2.js"></script>
            <form name="TinkoffPayForm" onSubmit={@pay} id="payForm">
                <input type="hidden" name="terminalkey" value="1539978299062"/>
                <input type="hidden" name="frame" value="true"/>
                <input type="hidden" name="language" value="ru"/>
                <input type="hidden" name="order" value={order}/>
                <input type="hidden" name="description" value="Оплата занятий на algoprog.ru"/>
                <input className="tinkoffPayRow" type="hidden" name="receipt" value={JSON.stringify(receipt)}/>
                <FieldGroup
                    id="amount"
                    label={LangRaw("payment_sum", @props.lang)}
                    type="text"
                    value={amount}
                    disabled/>
                <FieldGroup
                    id="name"
                    label={LangRaw("full_payer_name", @props.lang)}
                    type="text"
                    setField={@setField}
                    state={@state}/>
                <FieldGroup
                    id="email"
                    label={LangRaw("payer_email", @props.lang)}
                    type="text"
                    setField={@setField}
                    state={@state}/>
                <p>{LangRaw("you_agree_to_oferta", @props.lang)}</p>
                <Button type="submit" bsStyle="primary" disabled={!canSubmit}>
                    {LangRaw("do_pay", @props.lang)}
                </Button>
            </form>
            {LangRaw("payment_official", @props.lang)}

        </div>

export default withLang Payment