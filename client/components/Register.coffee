React = require('react')
import { CometSpinLoader } from 'react-css-loaders';

import Grid from 'react-bootstrap/lib/Grid'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import HelpBlock from 'react-bootstrap/lib/HelpBlock'
import Button from 'react-bootstrap/lib/Button'

import callApi from '../lib/callApi'

testSubmit = (event) ->
    event.preventDefault()
    username = document.getElementById("informatics-username").value
    password = document.getElementById("informatics-password").value
    console.log await callApi "informatics/userData", {username, password}

FieldGroup = ({ id, label, help, setField, state, props... }) =>
    onChange = (e) =>
        setField(id, e.target.value)
    value = if "value" of props then props.value else state[id]
    <FormGroup controlId={id}>
        <ControlLabel>{label}</ControlLabel>
        {`<FormControl {...props} value={value} onChange={onChange}/>`}
        {help && <HelpBlock>{help}</HelpBlock>}
    </FormGroup>


export default class Register extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            username: "111"
            password: "222"
            informatics_username: ""
            informatics_password: ""
        @setField = @setField.bind(this)
        @updateInformatics = @updateInformatics.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    updateInformatics: () ->
        if @state.informatics_username and @state.informatics_password
            newState = {
                @state...
                informaticsData:
                    loading: true
            }
            @setState(newState)
            try
                data = await callApi "informatics/userData", {
                    username: @state.informatics_username,
                    password: @state.informatics_password
                }
                console.log data
                if not ("name" of data)
                    throw "Can't find name"
            catch
                data =
                    error: true
            console.log data
            newState = {
                @state...
                informaticsData: data
            }
            @setState(newState)


    render: () ->
        <Grid fluid>
            <h1>Регистрация</h1>

            <form onSubmit={testSubmit}>
                <FieldGroup
                    id="username"
                    label="Имя пользователя"
                    type="text"
                    setField={@setField}
                    state={@state}/>
                <FieldGroup
                    id="password"
                    label="Пароль"
                    type="password"
                    setField={@setField}
                    state={@state}/>
                <h3>Ваш аккаунт на informatics.mccme.ru</h3>
                <p>Вам надо иметь аккаунт на сайте <a href="http://informatics.mccme.ru">informatics.mccme.ru</a>;
                ваши программы будут реально проверяться именно там. Если у вас еще нет аккаунта на
                informatics, <a href="http://informatics.mccme.ru/login/signup.php">зарегистрируйтесь сейчас</a>.</p>

                <p>Ниже вы должны будете указать логин и пароль от informatics. Пароль будет храниться на algoprog.ru.
                Он нужен, чтобы отправлять решения задач от вашего имени.
                Если вы используете этот же пароль на других сайтах, не вводите его ниже
                — сначала смените пароль на informatics, и только потом продолжайте.
                Если вы не хотите, чтобы я имел доступ к вашему аккаунту на informatics,
                просто зарегистрируйте новый аккаунт там и укажите ниже именно его.</p>

                <p>Укажите в аккаунте на informatics ваши настоящие имя и фамилию, а также верный год выпуска.</p>

                <FieldGroup
                    id="informatics_username"
                    label="Ваш логин на informatics"
                    type="text"
                    setField={@setField}
                    state={@state}
                    onBlur={@updateInformatics}/>
                <FieldGroup
                    id="informatics_password"
                    label="Ваш пароль на informatics"
                    type="password"
                    setField={@setField}
                    state={@state}
                    onBlur={@updateInformatics}/>

                <h2>Прочие данные</h2>
                <p>Они выгружаются из вашего аккаунта на informatics. Если они неверны,
                исправьте данные в вашем профиле там.</p>
                {@state.informaticsData?.loading && <CometSpinLoader />}
                {
                @state.informaticsData?.error &&
                <div>
                    Не удалось получить данные с informatics. Проверьте логин и пароль выше
                </div>
                }
                {
                @state.informaticsData?.name &&
                <div>
                    <FieldGroup
                        id="informatics_name"
                        label="Имя"
                        type="text"
                        value={@state.informaticsData.name || ""}
                        disabled/>
                    <FieldGroup
                        id="informatics_class"
                        label="Класс"
                        type="text"
                        value={@state.informaticsData.class || ""}
                        disabled/>
                    <FieldGroup
                        id="informatics_school"
                        label="Школа"
                        type="text"
                        value={@state.informaticsData.school || ""}
                        disabled/>
                    <FieldGroup
                        id="informatics_city"
                        label="Город"
                        type="text"
                        value={@state.informaticsData.city || ""}
                        disabled/>
                </div>
                }


                <h2>О вас</h2>
                <p>Напишите вкратце про себя. Как минимум — есть ли у вас опыт в программировании и какой;
                а также участвовали ли вы в олимпиадах по программированию и по математике.</p>

                <FormGroup controlId="aboutme">
                  <FormControl componentClass="textarea" placeholder="" />
                </FormGroup>

                <Button type="submit">
                    Зарегистрироваться
                </Button>
            </form>
        </Grid>
