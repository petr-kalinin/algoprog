React = require('react')

export default class Payment extends React.Component
    constructor: (props) ->
        super(props)

    pay: (e) ->
        console.log "try pay"
        form = document.getElementById("payForm")
        console.log form.terminalkey.value
        pay(form) 
        e.preventDefault()
        return false

    render: () ->
        <div>
            <h1>Оплата занятий</h1>
            <script src="https://securepay.tinkoff.ru/html/payForm/js/tinkoff_v2.js"></script>
            <form name="TinkoffPayForm" onSubmit={@pay} id="payForm">
                <input className="tinkoffPayRow" type="hidden" name="terminalkey" value="1539978299062DEMO"/>
                <input className="tinkoffPayRow" type="hidden" name="frame" value="true"/>
                <input className="tinkoffPayRow" type="hidden" name="language" value="ru"/>
                <input className="tinkoffPayRow" type="text" placeholder="Сумма заказа" name="amount" required value="1500"/>
                <input className="tinkoffPayRow" type="text" placeholder="Номер заказа" name="order" value="123"/>
                <input className="tinkoffPayRow" type="text" placeholder="Описание заказа" name="description" value="Тест"/>
                <input className="tinkoffPayRow" type="text" placeholder="ФИО плательщика" name="name" value="Василий Пупкин"/>
                <input className="tinkoffPayRow" type="text" placeholder="E-mail" name="email" value="petr@kalinin.nnov.ru"/>
                <input className="tinkoffPayRow" type="text" placeholder="Контактный телефон" name="phone" value="+79107943207"/>
                <input className="tinkoffPayRow" type="hidden" name="receipt" value='{"Taxation": "usn_income","Items": [ {"Name": "Наименование товара 1",
"Price": 150000,"Quantity": 1.00,"Amount": 150000,"Tax": "none" }]}'/>
                <input className="tinkoffPayRow" type="submit" value="Оплатить"/>
            </form>
        </div>
