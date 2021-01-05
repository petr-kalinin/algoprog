React = require('react')
moment = require('moment')

import Button from 'react-bootstrap/lib/Button'
import Alert from 'react-bootstrap/lib/Alert'
import { Link } from 'react-router-dom'

import FieldGroup from './FieldGroup'

export default class Payment extends React.Component
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
                    Вы не зарегистрированы, вы не можете оплачивать занятия. Форма ниже приведена для примера.
                </Alert>
            canSubmit = false
        else if not @props.myUser?.activated
            amount = 1500
            warning = <Alert bsStyle="danger">
                    Ваш аккаунт не активирован. Напишите мне, чтобы я активировал ваш аккаунт и установил стоимость занятий.
                    Форма ниже приведена для примера.
                </Alert>
            canSubmit = false
        else if @props.myUser.userList in ["lic40", "lic87", "zaoch", "graduated", "sbory"] or @props.myUser.price == 0
            amount = 0
            warning = <Alert bsStyle="danger">
                    Занятия для вас бесплатны, вам не надо их оплачивать.
                </Alert>
            canSubmit = false
        else if not @props.myUser.price or not @props.myUser.paidTill
            amount = 1500
            warning = <Alert bsStyle="danger">
                    Для вас не указана стоимость занятий, напишите мне.
                    Форма ниже приведена для примера.
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
            <h1>Оплата занятий</h1>
            {warning}
            <p>Вы оплачиваете один месяц занятий на algoprog.ru. Стоимость месяца для вас составляет {amount} рублей.</p>
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
                    label="Сумма"
                    type="text"
                    value={amount}
                    disabled/>
                <FieldGroup
                    id="name"
                    label="Полные ФИО плательщика"
                    type="text"
                    setField={@setField}
                    state={@state}/>
                <FieldGroup
                    id="email"
                    label="E-mail плательщика"
                    type="text"
                    setField={@setField}
                    state={@state}/>
                <p>Нажимая «Оплатить», вы соглашаетесь с <a href="/oferta.pdf" target="_blank">офертой</a> оказания услуг.</p>
                <Button type="submit" bsStyle="primary" disabled={!canSubmit}>
                    Оплатить
                </Button>
            </form>
            <h2>Официальная часть</h2>
            <p>Получатель платежа — ИП Калинин Петр Андреевич, ОГРНИП 318527500120581, ИНН 526210494064. 
            Контакты: petr@kalinin.nnov.ru, +7-910-794-32-07. (Полностью контакты указаны в разделе <Link to="/material/0">О курсе</Link>.)</p>

            <p>Платежи осуществляются через Тинькофф Банк. Принимаются карты любых банков.</p>
            <img height="30px" src="/tinkoff.png" style={{marginRight: "15px"}}/>
            <img height="30px" src="/mastercard_visa.svg"/>
        </div>
