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
                name: @state.name,
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
        passwordValidationState = null
        if @state.password and @state.password == @state.password2
            passwordValidationState = 'success'
        else if @state.password and @state.password2
            passwordValidationState = 'error'

        canSubmit = (passwordValidationState == 'success' and @state.username)

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
                <FieldGroup
                    id="name"
                    label="Имя, фамилия"
                    type="text"
                    setField={@setField}
                    state={@state}/>

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
