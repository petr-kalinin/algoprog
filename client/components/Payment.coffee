React = require('react')
moment = require('moment')

import Alert from 'react-bootstrap/lib/Alert'
import Button from 'react-bootstrap/lib/Button'
import Radio from 'react-bootstrap/lib/Radio'

import { Link } from 'react-router-dom'

import {LangRaw} from '../lang/lang'

import callApi from '../lib/callApi'
import ConnectedComponent from '../lib/ConnectedComponent'
import GROUPS from '../lib/groups'
import withLang from '../lib/withLang'

import FieldGroup from './FieldGroup'
import Loader from './Loader'

class TinkoffPayment extends React.Component
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
        canSubmit = @props.canSubmit
        amount = @props.amount
        order = @props.order
        receipt = 
            Taxation: "usn_income",
            Items: [ {
                Name: "Оплата занятий на algoprog.ru",
                Price: amount * 100,
                Quantity: 1.0,
                Amount: amount * 100,
                Tax: "none" 
            }]
        canSubmit = canSubmit and @state.name and @state.email

        <div>
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
            {LangRaw("payment_official_tinkoff", @props.lang)}

        </div>

class XSollaPayment extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            name: ""
            email: ""
            address: ""
            loading: false
            error: false
        @setField = @setField.bind(this)
        @pay = @pay.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    pay: (e) ->
        e.preventDefault()
        @setState
            loading: true
        try
            data = await callApi "xsollaToken", {
                order: @props.order,
                name: @state.name,
                email: @state.email,
                address: @state.address
            }
            if not data.token
                throw "Error"
        catch e
            console.log e
            @setState
                error: true
                loading: false
            return
        @setState
            error: false
            loading: false
        open("https://sandbox-secure.xsolla.com/paystation3/?access_token=#{data.token}", '_blank').focus()


    render: () ->
        canSubmit = @props.canSubmit and @state.name and @state.email and @state.address
        amount = @props.amount
        <div>
            {@state.loading && <Loader /> }
            {!@state.loading && 
                <form onSubmit={@pay}>
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
                    <FieldGroup
                        id="address"
                        label={LangRaw("payer_address", @props.lang)}
                        type="text"
                        setField={@setField}
                        state={@state}/>
                    {@state.error && <Alert bsStyle="danger">
                        {LangRaw("unknown_error", @props.lang)}
                    </Alert>}
                    <p>{LangRaw("you_agree_to_oferta", @props.lang)}</p>
                    <Button type="submit" bsStyle="primary" disabled={!canSubmit}>
                        {LangRaw("do_pay", @props.lang)}
                    </Button>
                </form>    
            }
        </div>

class UnitpayPayment extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            name: ""
            email: ""
            address: ""
            loading: false
            error: false
        @setField = @setField.bind(this)
        @pay = @pay.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    pay: (e) ->
        e.preventDefault()
        @setState
            loading: true
        try
            data = await callApi "unitpaySignature", {
                order: @props.order,
                name: @state.name,
                email: @state.email,
                address: @state.address,
                desc: LangRaw("payment_for_one_month", @props.lang)
            }
            if (not data.signature) or (not data.publicKey) or (not data.desc) or (not data.currency) or (not data.order) or (not data.sum)
                throw "Error"
        catch e
            console.log e
            @setState
                error: true
                loading: false
            return
        @setState
            error: false
            loading: false
        open("https://unitpay.ru/pay/#{data.publicKey}?sum=#{data.sum}&account=#{data.order}&desc=#{data.desc}&currency=#{data.currency}&signature=#{data.signature}", '_blank').focus()


    render: () ->
        canSubmit = @props.canSubmit and @state.name and @state.email
        amount = @props.amount
        <div>
            {@state.loading && <Loader /> }
            {!@state.loading && 
                <form onSubmit={@pay}>
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
                    {@state.error && <Alert bsStyle="danger">
                        {LangRaw("unknown_error", @props.lang)}
                    </Alert>}
                    <Button type="submit" bsStyle="primary" disabled={!canSubmit}>
                        {LangRaw("do_pay", @props.lang)}
                    </Button>
                    <p>{LangRaw("you_agree_to_oferta", @props.lang)}</p>
                    {LangRaw("payment_official_unitpay", @props.lang)}
                </form>    
            }
        </div>

class EvocaPayment extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            name: ""
            email: ""
            address: ""
            loading: false
            error: false
        @setField = @setField.bind(this)
        @pay = @pay.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    pay: (e) ->
        e.preventDefault()
        @setState
            loading: true
        try
            data = await callApi "evocaData", {
                order: @props.order,
                name: @state.name,
                email: @state.email,
                address: @state.address,
                desc: LangRaw("payment_for_one_month", @props.lang)
            }
            if not data.formUrl
                throw "Error"
        catch e
            console.log e
            @setState
                error: true
                loading: false
            return
        @setState
            error: false
            loading: false
        open(data.formUrl, '_blank').focus()


    render: () ->
        canSubmit = @props.canSubmit and @state.name and @state.email and @state.address
        amount = @props.amount
        <div>
            {@state.loading && <Loader /> }
            {!@state.loading && 
                <form onSubmit={@pay}>
                    <FieldGroup
                        id="amount"
                        label={LangRaw("payment_sum", @props.lang)}
                        type="text"
                        value={"#{@props.evocaPreData.amount} #{@props.evocaPreData.currency} (#{amount} RUB + 10%)" }
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
                    <FieldGroup
                        id="address"
                        label={LangRaw("payer_address", @props.lang)}
                        type="text"
                        setField={@setField}
                        state={@state}/>
                    {@state.error && <Alert bsStyle="danger">
                        {LangRaw("unknown_error", @props.lang)}
                    </Alert>}
                    <Button type="submit" bsStyle="primary" disabled={!canSubmit}>
                        {LangRaw("do_pay", @props.lang)}
                    </Button>
                    <p>{LangRaw("you_agree_to_oferta", @props.lang)}</p>
                    {LangRaw("payment_official_evoca", @props.lang)}
                </form>    
            }
        </div>

evocaOptions =
    urls: (props) ->
        evocaPreData: "evocaPreData"

EvocaPayment = ConnectedComponent(EvocaPayment, evocaOptions)

class PaymentSelector extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            provider: null
        @setField = @setField.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    render: () ->
        <div>
            <FieldGroup
                id="provider"
                label=""
                type="radio"
                setField={@setField}
                state={@state}>
                    {"tinkoff" in @props.providers && <Radio name="provider" onChange={(e) => @setField("provider", "tinkoff")} className="lead">{LangRaw("pay_with_russian_card", @props.lang)}</Radio>}
                    {"unitpay" in @props.providers && <Radio name="provider" onChange={(e) => @setField("provider", "unitpay")} className="lead">{LangRaw("pay_with_foreign_card", @props.lang)}</Radio>}
                    {"evoca" in @props.providers && <Radio name="provider" onChange={(e) => @setField("provider", "evoca")} className="lead">{LangRaw("pay_with_foreign_card_evoca", @props.lang)}</Radio>}
            </FieldGroup>
            {@state.provider == "tinkoff" && <TinkoffPayment {@props...}/> }
            {@state.provider == "unitpay" && <UnitpayPayment {@props...}/> }
            {@state.provider == "evoca" && <EvocaPayment {@props...}/> }
        </div>

class Payment extends React.Component
    render: () ->
        canSubmit = true
        amount = 2000
        if not @props.myUser?._id
            warning = <Alert bsStyle="danger">
                    {LangRaw("cant_pay_not_registered", @props.lang)}
                </Alert>
            canSubmit = false
        else if not @props.myUser?.activated
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
            warning = <Alert bsStyle="danger">
                    {LangRaw("cant_pay_no_price", @props.lang)}
                </Alert>
            canSubmit = false
        else 
            amount = @props.myUser.price
            warning = null
        switch GROUPS[@props.myUser?.userList]?.paid
            when "tinkoff" then providers = ["tinkoff", "unitpay", "evoca"]
            when "unitpay" then providers = ["tinkoff", "unitpay", "evoca"]
            when "evoca" then providers = ["tinkoff", "unitpay", "evoca"]
            else
                canSubmit = false
                providers = ["tinkoff", "unitpay", "evoca"]
        if @props.myUser?.paidTill
            paidTill = moment(@props.myUser.paidTill).utc().format("YYYYMMDD")
            order = "#{@props.myUser._id}:#{paidTill}"
        else
            order = ""
        <div>
            <script src="https://securepay.tinkoff.ru/html/payForm/js/tinkoff_v2.js"></script>
            <h1>{LangRaw("payment_for_the_course", @props.lang)}</h1>
            {warning}
            <p>{LangRaw("you_pay_for_one_month", @props.lang)(amount)}</p>
            <PaymentSelector providers={providers} {@props...} canSubmit={canSubmit} amount={amount} order={order}/>
        </div>

export default withLang Payment