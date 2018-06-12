React = require('react')
import { CometSpinLoader } from 'react-css-loaders';
import { withRouter } from 'react-router'

import Grid from 'react-bootstrap/lib/Grid'
import Form from 'react-bootstrap/lib/Form'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import HelpBlock from 'react-bootstrap/lib/HelpBlock'
import Button from 'react-bootstrap/lib/Button'
import Modal from 'react-bootstrap/lib/Modal'

import { Link } from 'react-router-dom'

import { connect } from 'react-redux'

import callApi from '../lib/callApi'

import * as actions from '../redux/actions'

import FieldGroup from './FieldGroup'

class Register extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            username: ""
            password: ""
            password2: ""
            informaticsUsername: ""
            informaticsPassword: ""
            aboutme: ""
            cfLogin: ""
        @setField = @setField.bind(this)
        @updateInformatics = @updateInformatics.bind(this)
        @tryRegister = @tryRegister.bind(this)
        @closeModal = @closeModal.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    updateInformatics: () ->
        if @state.informaticsUsername and @state.informaticsPassword
            newState = {
                @state...
                informaticsData:
                    loading: true
            }
            @setState(newState)
            try
                data = await callApi "informatics/userData", {
                    username: @state.informaticsUsername,
                    password: @state.informaticsPassword
                }
                if not ("name" of data)
                    throw "Can't find name"
            catch
                data =
                    error: true
            newState = {
                @state...
                informaticsData: data
            }
            @setState(newState)

    tryRegister: (event) ->
        event.preventDefault()
        newState = {
            @state...
            registered:
                loading: true
        }
        @setState(newState)
        try
            data = await callApi "register", {
                username: @state.username,
                password: @state.password,
                informaticsUsername: @state.informaticsUsername,
                informaticsPassword: @state.informaticsPassword
                aboutme: @state.aboutme
            }
            if data.registered.success
                await callApi "login", {
                    username: @state.username,
                    password: @state.password
                }
                @props.reloadMyData()
        catch
            data =
                registered:
                    error: true
                    message: "Неопознанная ошибка"
        newState = {
            @state...
            registered: data.registered
        }
        @setState(newState)

    closeModal: () ->
        if @state.registered.error
            newState = {@state..., registered: null}
            @setState(newState)
        else
            @props.history.push("/")

    render: () ->
        validationState = null
        if @state.informaticsData?.name
            validationState = 'success'
        else if @state.informaticsData?.error
            validationState = 'error'
        else if @state.informaticsData?.loading
            validationState = 'warning'

        passwordValidationState = null
        if @state.password and @state.password == @state.password2
            passwordValidationState = 'success'
        else if @state.password and @state.password2
            passwordValidationState = 'error'

        canSubmit = (validationState == 'success' and passwordValidationState == 'success' and @state.username)

        <Grid fluid>
            <h1>Регистрация</h1>

            <form onSubmit={@tryRegister}>
                <FieldGroup
                    id="username"
                    label="Логин"
                    type="text"
                    setField={@setField}
                    state={@state}/>
                <FieldGroup
                    id="password"
                    label="Пароль"
                    type="password"
                    setField={@setField}
                    state={@state}
                    validationState={passwordValidationState}/>
                <FieldGroup
                    id="password2"
                    label="Подтвердите пароль"
                    type="password"
                    setField={@setField}
                    state={@state}
                    validationState={passwordValidationState}/>
                <h3>Ваш аккаунт на informatics.mccme.ru</h3>
                <p>Вам надо иметь аккаунт на сайте <a href="https://informatics.mccme.ru">informatics.mccme.ru</a>;
                ваши программы будут реально проверяться именно там. Если у вас еще нет аккаунта на
                informatics, <a href="https://informatics.mccme.ru/login/signup.php">зарегистрируйтесь сейчас</a>.</p>

                <p>Ниже вы должны будете указать логин и пароль от informatics. Пароль будет храниться на algoprog.ru.
                Он нужен, чтобы отправлять решения задач от вашего имени.
                Если вы используете этот же пароль на других сайтах, не вводите его ниже
                — сначала смените пароль на informatics, и только потом продолжайте.
                Если вы не хотите, чтобы я имел доступ к вашему аккаунту на informatics,
                просто зарегистрируйте новый аккаунт там и укажите ниже именно его.</p>

                <p>Укажите в аккаунте на informatics свои настоящие данные.
                Если вы уже закончили школу, то не заполняйте поле "класс".</p>

                <FieldGroup
                    id="informaticsUsername"
                    label="Ваш логин на informatics"
                    type="text"
                    setField={@setField}
                    state={@state}
                    onBlur={@updateInformatics}
                    validationState={validationState}/>
                <FieldGroup
                    id="informaticsPassword"
                    label="Ваш пароль на informatics"
                    type="password"
                    setField={@setField}
                    state={@state}
                    onBlur={@updateInformatics}
                    validationState={validationState}/>

                <h2>Личная информация</h2>
                <p><span>Она выгружается из вашего аккаунта на informatics. Если данные ниже неверны,
                исправьте данные </span>
                {
                if @state.informaticsData?.id
                    <a href={"https://informatics.mccme.ru/user/edit.php?id=#{@state.informaticsData?.id}&course=1"}>в вашем профиле там.</a>
                else
                    <span>в вашем профиле там.</span>
                }
                </p>
                {
                @state.informaticsData?.loading && <div>
                    <p>Informatics бывает подтормаживает, поэтому загрузка данных может занять некоторое время.</p>
                    <CometSpinLoader />
                </div>}
                {
                @state.informaticsData?.error &&
                <FormGroup>
                    <FormControl.Static>
                    Не удалось получить данные с informatics. Проверьте логин и пароль выше.
                    </FormControl.Static>
                </FormGroup>
                }
                {@state.informaticsData && !@state.informaticsData.loading &&
                <FormGroup>
                    <Button onClick={@updateInformatics}>
                        Обновить информацию
                    </Button>
                </FormGroup>
                }
                {
                (@state.informaticsData?.name or not @state.informaticsData)&&
                <div>
                    <FieldGroup
                        id="informaticsName"
                        label="Имя"
                        type="text"
                        value={@state.informaticsData?.name || ""}
                        disabled/>
                    <FieldGroup
                        id="informaticsClass"
                        label={"Класс" + (@state.informaticsData &&
                        " в #{@state.informaticsData.currentYearStart}-#{@state.informaticsData.currentYearStart+1} учебном году" || "")}
                        type="text"
                        value={@state.informaticsData?.class || ""}
                        disabled/>
                    <FieldGroup
                        id="informaticsSchool"
                        label="Школа"
                        type="text"
                        value={@state.informaticsData?.school || ""}
                        disabled/>
                    <FieldGroup
                        id="informaticsCity"
                        label="Город"
                        type="text"
                        value={@state.informaticsData?.city || ""}
                        disabled/>
                </div>
                }

                <h2>Аккаунт на codeforces</h2>

                <p>Укажите свой логин на codeforces, если он у вас есть. Если вы там не зарегистрированы — не страшно,
                просто не заполняйте поле ниже.</p>
                <FieldGroup
                    id="cfLogin"
                    label=""
                    type="text"
                    setField={@setField}
                    state={@state}/>

                <h2>О себе</h2>
                <p>Напишите вкратце про себя. Как минимум — есть ли у вас опыт в программировании и какой;
                а также участвовали ли вы в олимпиадах по программированию и по математике. Если вы уже занимались в этом курсе,
                можете не писать ничего.</p>

                <FormGroup controlId="aboutme">
                    <FieldGroup
                        id="aboutme"
                        label=""
                        componentClass="textarea"
                        setField={@setField}
                        state={@state}/>
                </FormGroup>

                <Button type="submit" bsStyle="primary" disabled={!canSubmit}>
                    Зарегистрироваться
                </Button>
            </form>
            {
            @state.registered &&
            <div className="static-modal">
                <Modal.Dialog>
                    <Modal.Header>
                        <Modal.Title>Регистрация</Modal.Title>
                    </Modal.Header>

                    <Modal.Body>
                        {@state.registered.loading && <CometSpinLoader />}
                        {@state.registered.error && "Ошибка: " + @state.registered.message}
                        {@state.registered.success &&
                            <div>
                                <p>Регистрация успешна!</p>
                                <p><b>Если вы еще не занимались в этом курсе, обязательно напишите мне о том, что вы зарегистрировались,
                                чтобы я активировал вашу учетную запись. Мои контакты — на страничке
                                {" "}<Link to="/material/0">О курсе</Link>.</b></p>
                            </div>}
                    </Modal.Body>

                    <Modal.Footer>
                        {not @state.registered.loading && <Button bsStyle="primary" onClick={@closeModal}>OK</Button>}
                    </Modal.Footer>

                </Modal.Dialog>
            </div>
            }
        </Grid>

mapStateToProps = () ->
    {}

mapDispatchToProps = (dispatch) ->
    return
        reloadMyData: () -> dispatch(actions.invalidateAllData())

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(Register))
