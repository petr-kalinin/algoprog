React = require('react')
import { withRouter } from 'react-router'
import { connect } from 'react-redux'

import Grid from 'react-bootstrap/lib/Grid'
import Form from 'react-bootstrap/lib/Form'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import HelpBlock from 'react-bootstrap/lib/HelpBlock'
import Button from 'react-bootstrap/lib/Button'

import { Redirect } from 'react-router-dom'

import Loader from '../components/Loader'

import callApi from '../lib/callApi'
import withMyUser from '../lib/withMyUser'

import FieldGroup from './FieldGroup'

import * as actions from '../redux/actions'

class Login extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            username: ""
            password: ""
        @setField = @setField.bind(this)
        @tryLogin = @tryLogin.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    tryLogin: (event) ->
        event.preventDefault()
        newState = {
            @state...
            loading: true
        }
        @setState(newState)
        try
            data = await callApi "login", {
                username: @state.username,
                password: @state.password,
            }
            if not data.logged
                throw "Error"
            @props.reloadMyData()
            @props.history.goBack()
        catch
            data =
                error: true
                message: "Неверный логин или пароль"
            newState = {
                @state...,
                loading: false,
                data...
            }
            @setState(newState)


    render:  () ->
        if @props.myUser?._id
            return <Redirect to="/user/#{@props.myUser._id}" />
        canSubmit = @state.username && @state.password && !@state.loading
        <Grid fluid>
            <h1>Вход в систему</h1>

            <form onSubmit={@tryLogin} autoComplete="off">
                <input type="text" style={{display:"none"}}/>
                <input type="password" style={{display:"none"}}/>
                {
                if not @state.loading
                    <div>
                        <FieldGroup
                            id="username"
                            label="Логин"
                            type="text"
                            setField={@setField}
                            state={@state}
                            validationState={@state.error && 'error'}/>
                        <FieldGroup
                            id="password"
                            label="Пароль"
                            type="password"
                            setField={@setField}
                            state={@state}
                            validationState={@state.error && 'error'}/>
                    </div>
                else
                    <Loader/>
                }
                {
                @state.message &&
                <FormGroup>
                    <FormControl.Static>
                        {@state.message}
                    </FormControl.Static>
                </FormGroup>
                }
                <Button type="submit" bsStyle="primary" disabled={!canSubmit}>
                    Войти
                </Button>
            </form>
        </Grid>

mapStateToProps = () ->
    {}

mapDispatchToProps = (dispatch) ->
    return
        reloadMyData: () -> dispatch(actions.invalidateAllData())

export default withMyUser(withRouter(connect(mapStateToProps, mapDispatchToProps)(Login)))
