React = require('react')
import { connect } from 'react-redux'
import { withRouter } from 'react-router'
import { Link } from 'react-router-dom'

import Alert from 'react-bootstrap/lib/Alert'
import Button from 'react-bootstrap/lib/Button'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import Form from 'react-bootstrap/lib/Form'
import FormControl from 'react-bootstrap/lib/FormControl'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import Grid from 'react-bootstrap/lib/Grid'
import HelpBlock from 'react-bootstrap/lib/HelpBlock'
import Modal from 'react-bootstrap/lib/Modal'
import Radio from 'react-bootstrap/lib/Radio'

import {LangRaw} from '../lang/lang'

import callApi from '../lib/callApi'
import withLang from '../lib/withLang'
import {getCurrentYearStart} from '../lib/graduateYearToClass'

import * as actions from '../redux/actions'

import FieldGroup from './FieldGroup'
import Loader from './Loader'

ERROR_MESSAGE_TO_LANG_ID =
    duplicate: "user_with_such_login_exists"
    unknown: "unknown_error"

class Register extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            username: ""
            password: ""
            password2: ""
            informaticsUsername: ""
            informaticsPassword: ""
            promo: ""
            contact: ""
            whereFrom: ""
            aboutme: ""
            cfLogin: ""
            hasInformatics: undefined
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
                informaticsLoading: true
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
                informaticsLoading: false
                informaticsName: data.name
                informaticsClass: data.class
                informaticsSchool: data.school
                informaticsCity: data.city
                informaticsError: data.error
                informaticsId: data.id
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
                username: @state.username
                password: @state.password
                informaticsUsername: @state.hasInformatics && @state.informaticsUsername
                informaticsPassword: @state.hasInformatics && @state.informaticsPassword
                informaticsName: @state.informaticsName
                informaticsClass: @state.informaticsClass
                informaticsSchool: @state.informaticsSchool
                informaticsCity: @state.informaticsCity
                promo: @state.promo
                whereFrom: @state.whereFrom
                contact: @state.contact
                aboutme: @state.aboutme
                cfLogin: @state.cfLogin
            }
            if data.registered.success
                if window.yaCounter45895896
                    window.yaCounter45895896.hit?("/registration_done")
                await callApi "login", {
                    username: @state.username,
                    password: @state.password
                }
                @props.reloadMyData()
        catch
            data =
                registered:
                    error: true
                    message: "unknown"
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
        Lang = (id) => LangRaw(id, @props.lang)
        validationState = null
        if (@state.informaticsName && @state.hasInformatics) || (not @state.hasInformatics && @state.informaticsName)
            validationState = 'success'
        else if @state.informaticsError
            validationState = 'error'
        else if @state.informaticsLoading
            validationState = 'warning'

        passwordValidationState = null
        passwordError = null
        if @state.password and @state.password == @state.password2
            if @state.password.startsWith(' ') or @state.password.endsWith(' ')
                passwordValidationState = 'error'
                passwordError = Lang("password_cant_start_with_space")
            else
                passwordValidationState = 'success'
        else if @state.password and @state.password2
            passwordValidationState = 'error'
            passwordError = Lang("passwords_are_not_equal")

        loginValidationState = 'success'
        loginError = null
        if @state.username.length == 0
            loginValidationState = 'error'
        else if @state.username.startsWith(' ') or @state.username.endsWith(' ')
            loginValidationState = 'error'
            loginError = Lang("username_cant_start_with_space")

        canSubmit = (validationState == 'success' and passwordValidationState == 'success' and loginValidationState == 'success')
        hasInformatics = @state.hasInformatics
        yearStart = getCurrentYearStart()

        <Grid fluid>
            <h1>{Lang("register")}</h1>

            <form onSubmit={@tryRegister}>
                <FieldGroup
                    id="username"
                    label={Lang("login")}
                    type="text"
                    setField={@setField}
                    state={@state}
                    validationState={loginValidationState}
                    error={loginError}/>
                <FieldGroup
                    id="password"
                    label={Lang("password")}
                    type="password"
                    setField={@setField}
                    state={@state}
                    validationState={passwordValidationState}
                    error={passwordError}/>
                <FieldGroup
                    id="password2"
                    label={Lang("repeat_password")}
                    type="password"
                    setField={@setField}
                    state={@state}
                    validationState={passwordValidationState}/>

                <h3>{Lang("account_on_informatics")}</h3>
                {Lang("you_need_to_have_informatics_account")}
                

                <FieldGroup
                    id="hasInformatics"
                    label=""
                    type="radio"
                    setField={@setField}
                    state={@state}
                    onBlur={@updateInformatics}
                    validationState={validationState}>
                        <Radio name="hasInformatics" onChange={(e) => @setField("hasInformatics", false)} className="lead">{Lang("i_dont_have_informatics_account")}</Radio>
                        <Radio name="hasInformatics" onChange={(e) => @setField("hasInformatics", true)} className="lead">{Lang("i_have_informatics_account")}</Radio>
                </FieldGroup>

                {hasInformatics == true &&
                    <>
                        {Lang("please_specify_informatics_account")}

                        <FieldGroup
                            id="informaticsUsername"
                            label={Lang("your_informatics_login")}
                            type="text"
                            setField={@setField}
                            state={@state}
                            onBlur={@updateInformatics}
                            validationState={validationState}/>
                        <FieldGroup
                            id="informaticsPassword"
                            label={Lang("your_informatics_password")}
                            type="password"
                            setField={@setField}
                            state={@state}
                            onBlur={@updateInformatics}
                            validationState={validationState}/>
                    </>
                }
                {hasInformatics == false && 
                    <Alert bsStyle="danger">
                        {Lang("automatic_registration_is_experimental")}
                    </Alert>
                }
                {hasInformatics? &&
                    <>
                    <h2>{Lang("personal_information")}</h2>
                    {hasInformatics == true && <>
                        {Lang("it_is_downloaded_from_informatics")(@state.informatics_id)}
                        {
                        @state.informaticsLoading && <div>
                            <p>{Lang("informatics_may_be_slow")}</p>
                            <Loader />
                        </div>}
                        {
                        @state.informaticsError &&
                        <FormGroup>
                            <FormControl.Static>
                            {Lang("cant_get_your_informatics_data")}
                            </FormControl.Static>
                        </FormGroup>
                        }
                        {@state.hasInformatics && !@state.informaticsLoading &&
                        <FormGroup>
                            <Button onClick={@updateInformatics}>
                                {Lang("refresh_info")}
                            </Button>
                        </FormGroup>
                        }
                        </>
                    }
                    {(hasInformatics == false or (@state.informaticsName and not @state.informaticsLoading))&&
                    <div>
                        <p>{Lang("do_not_fill_class")}</p>
                        <FieldGroup
                            id="informaticsName"
                            label={Lang("name_surname")}
                            type="text"
                            setField={@setField}
                            state={@state}
                            disabled={hasInformatics}/>
                        <FieldGroup
                            id="informaticsClass"
                            label={Lang("class_in_year")(yearStart)}
                            type="text"
                            setField={@setField}
                            state={@state}
                            disabled={hasInformatics}/>
                        <FieldGroup
                            id="informaticsSchool"
                            label={Lang("school")}
                            type="text"
                            setField={@setField}
                            state={@state}
                            disabled={hasInformatics}/>
                        <FieldGroup
                            id="informaticsCity"
                            label={Lang("city")}
                            type="text"
                            setField={@setField}
                            state={@state}
                            disabled={hasInformatics}/>
                    </div>
                    }

                    <h2>{Lang("about_yourself")}</h2>
                    <p>{Lang("about_yourself_note")}</p>

                    <FormGroup controlId="aboutme">
                        <FieldGroup
                            id="aboutme"
                            label=""
                            componentClass="textarea"
                            setField={@setField}
                            state={@state}/>
                    </FormGroup>

                    <p>{Lang("how_did_you_find_about_course")}</p>

                    <FormGroup controlId="whereFrom">
                        <FieldGroup
                            id="whereFrom"
                            label=""
                            componentClass="input"
                            setField={@setField}
                            state={@state}/>
                    </FormGroup>

                    <p>{Lang("specify_your_contacts")}</p>

                    <FormGroup controlId="contact">
                        <FieldGroup
                            id="contact"
                            label=""
                            componentClass="input"
                            setField={@setField}
                            state={@state}/>
                    </FormGroup>

                    <p>{Lang("specify_your_cf")}</p>
                    <FieldGroup
                        id="cfLogin"
                        label=""
                        type="text"
                        setField={@setField}
                        state={@state}/>

                    <p>{Lang("promocode")}</p>

                    <FormGroup controlId="promo">
                        <FieldGroup
                            id="promo"
                            label=""
                            componentClass="input"
                            setField={@setField}
                            state={@state}/>
                    </FormGroup>

                    <Button type="submit" bsStyle="primary" disabled={!canSubmit}>
                        {Lang("do_register")}
                    </Button>
                    </>
                }
            </form>
            {
            @state.registered &&
            <div className="static-modal">
                <Modal.Dialog>
                    <Modal.Header>
                        <Modal.Title>{Lang("register")}</Modal.Title>
                    </Modal.Header>

                    <Modal.Body>
                        {@state.registered.loading && 
                            <>
                                <p>{Lang("informatics_may_be_slow_so_register_is_slow")}</p>
                                <Loader />
                            </>
                        }
                        {@state.registered.error && Lang("error") + ": " + Lang(ERROR_MESSAGE_TO_LANG_ID[@state.registered.message] || "unknown_error")}
                        {@state.registered.success &&
                            <div>
                                <p>{Lang("register_success")}</p>
                                <p><b>{Lang("contact_me_for_activation")}</b></p>
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

export default withLang(withRouter(connect(mapStateToProps, mapDispatchToProps)(Register)))
