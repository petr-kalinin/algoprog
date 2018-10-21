React = require('react')

import Button from 'react-bootstrap/lib/Button'
import { Link } from 'react-router-dom'

import FieldGroup from './FieldGroup'

export default class Payment extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            name: ""
            email: ""
            phone: ""
            amount: 1500
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
        receipt = 
            Taxation: "usn_income",
            Items: [ {
                Name: "Оплата занятий на algoprog.ru",
                Price: @state.amount * 100,
                Quantity: 1.0,
                Amount: @state.amount * 100,
                Tax: "none" 
            }]
        order = Math.floor(Math.random() * 1e9)

        <div>
            <h1>Оплата занятий</h1>
            <p>Вы оплачиваете один месяц занятий на algoprog.ru. Стоимость месяца составляет {@state.amount} рублей.</p>
            <script src="https://securepay.tinkoff.ru/html/payForm/js/tinkoff_v2.js"></script>
            <form name="TinkoffPayForm" onSubmit={@pay} id="payForm">
                <input type="hidden" name="terminalkey" value="1539978299062DEMO"/>
                <input type="hidden" name="frame" value="true"/>
                <input type="hidden" name="language" value="ru"/>
                <input type="hidden" name="order" value={order}/>
                <input type="hidden" name="description" value="Оплата занятий на algoprog.ru"/>
                <input className="tinkoffPayRow" type="hidden" name="receipt" value={JSON.stringify(receipt)}/>
                <FieldGroup
                    id="amount"
                    label="Сумма"
                    type="text"
                    value={@state.amount}
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
                <FieldGroup
                    id="phone"
                    label="Телефон плательщика"
                    type="text"
                    setField={@setField}
                    state={@state}/>
                <p>Нажимая «Оплатить», вы соглашаетесь с <a href="/oferta.pdf" target="_blank">офертой</a> оказания услуг.</p>
                <Button type="submit" bsStyle="primary">
                    Оплатить
                </Button>
            </form>
            <h2>Официальная часть</h2>
            <p>Получатель платежа — ИП Калинин Петр Андреевич, ОГРНИП 318527500120581, ИНН 526210494064. 
            Контакты: petr@kalinin.nnov.ru, +7-910-794-32-07. (Полностью контакты указаны в разделе <Link to="/material/0">О курсе</Link>.)</p>

            <p>Платежи осуществляются через Тинькофф Банк.</p>
            <img height="30px" src="/tinkoff.png" style={{"margin-right": "15px"}}/>
            <img height="30px" src="/mastercard_visa.svg"/>
        </div>
