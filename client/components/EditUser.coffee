React = require('react')

import Button from 'react-bootstrap/lib/Button'

import CfStatus from './CfStatus'
import styles from './EditUser.css'
import Loader from './Loader'

import Lang, {LangRaw} from '../lang/lang'

import callApi from '../lib/callApi'
import ConnectedComponent from '../lib/ConnectedComponent'
import {getClassStartingFromJuly} from '../lib/graduateYearToClass'
import withLang from '../lib/withLang'

class Input extends React.Component
    constructor: (props) ->
        super(props)

    render: ()->
        errors = @props.errors?.map(
            (val, i)->
                if val
                    <div className = "#{styles.youHaveProblem} alert-danger" key={i}>{val}</div>
                    )
        if errors
            errors = (q for q in errors when q)
            if errors.length == 0 then errors = undefined
        <div className = {styles.divInput}>
            <input
                type = {@props.type}
                name = {@props.name}
                className = "#{styles.inp} #{errors &&  styles.error}"
                value = {@props.value}
                onChange = {@props.onChange}
                onBlur = {@props.onBlur}
                onKeyPress = {@props.onKeyPress}
            />
            {if !@props.hideErrors
                <div>
                    {errors}
                </div>
                }
        </div>

class EditingUser extends React.Component
    constructor: (props) ->
        super(props)
        @state = @startState(props)
        @handleNewNameChange = @handleNewNameChange.bind(this)
        @handleCfChange = @handleCfChange.bind(this)
        @handleTelegramChange = @handleTelegramChange.bind(this)
        @handleClassChange = @handleClassChange.bind(this)
        @handleInformaticsPasswordChange = @handleInformaticsPasswordChange.bind(this)
        @handleCodeforcesUsernameChange = @handleCodeforcesUsernameChange.bind(this)
        @handleCodeforcesPasswordChange = @handleCodeforcesPasswordChange.bind(this)
        @updateInformatics = @updateInformatics.bind(this)
        @updateCodeforces = @updateCodeforces.bind(this)
        @handleNewPassOneChange = @handleNewPassOneChange.bind(this)
        @handleNewPassTwoChange = @handleNewPassTwoChange.bind(this)
        @handlePasswordChange = @handlePasswordChange.bind(this)
        @submit = @submit.bind(this)
        @handleKeyPressed = @handleKeyPressed.bind(this)

    startState: (props) ->
        return
            cfLogin: props.user.cf?.login || ''
            password: ''
            clas: getClassStartingFromJuly(@props.user.graduateYear) || ''
            codeforcesUsername: props.registeredUser.codeforcesUsername
            codeforcesPassword: ''
            newPassOne: ''
            newPassTwo: ''
            informaticsPassword: ''
            newTelegram: props.user.telegram || ''
            loading: false
            informaticsError: false
            informaticsLoading: false
            codeforcesLoading: false
            passError: false
            newName: @props.user.name
            unknownError: false

    handleKeyPressed: (e)->
        if e.key == "Enter"
            @submit()

    updateInformatics: ()->
        await @setState informaticsLoading: true
        if (@state.informaticsPassword != '')
            try
                data = await callApi "informatics/userData", {
                    username: @props.me.informaticsUsername,
                    password: @state.informaticsPassword
                }
                if not ("name" of data)
                    throw "Can't find name"
                await @setState informaticsError: false
            catch
                    await @setState informaticsError: true
        else
                await @setState informaticsError: false
        await @setState informaticsLoading: false

    updateCodeforces: ()->
        await @setState codeforcesLoading: true
        if (@state.codeforcesPassword != '' and @state.codeforcesUsername != '')
            try
                data = await callApi "codeforces/userData", {
                    username: @state.codeforcesUsername
                    password: @state.codeforcesPassword
                }
                if not data.status
                    throw "Wrong codeforces"
                @setState codeforcesError: false
            catch
                @setState codeforcesError: true
        else
            @setState codeforcesError: false
        @setState codeforcesLoading: false

    submit: ()->
        try
            await @setState loading: true
            window.scrollTo(0, 0)
            z = await callApi('user/' + @props.user._id + '/set',
                cf:
                    login: @state.cfLogin
                password: @state.password
                clas: @state.clas
                newPassword: @state.newPassOne
                informaticsPassword: @state.informaticsPassword
                informaticsUsername: @props.me.informaticsUsername
                newName: @state.newName
                codeforcesUsername: @state.codeforcesUsername
                codeforcesPassword: @state.codeforcesPassword
                telegram: @state.newTelegram
                )
            if (z.passError)
                await @setState passError: true
            else
                window.goto("/user/#{@props.user._id}")()
            await @setState loading: false
        catch
            @setState unknownError: true

    handleCfChange: (event) ->
        await @setState cfLogin: event.target.value
        
    handleTelegramChange: (event) ->
        await @setState newTelegram: event.target.value

    handleCodeforcesUsernameChange: (event)->
        await @setState codeforcesUsername: event.target.value

    handleCodeforcesPasswordChange: (event)->
        await @setState codeforcesPassword: event.target.value

    handlePasswordChange: (event) ->
        await @setState password: event.target.value, passError: false

    handleNewPassTwoChange: (event)->
        await @setState newPassTwo: event.target.value

    handleNewPassOneChange: (event)->
        await @setState newPassOne: event.target.value

    handleClassChange: (event)->
        await @setState clas: event.target.value

    handleNewNameChange: (event)->
        await @setState newName: event.target.value

    handleInformaticsPasswordChange: (event)->
        await @setState informaticsPassword: event.target.value

    render: () ->
        if @state.loading
            <Loader />
        else
            noMatch = (@state.newPassOne != @state.newPassTwo)
            whitespace = (@state.newPassOne.startsWith(' ') or @state.newPassTwo.startsWith(' ') or @state.newPassOne.endsWith(' ') or @state.newPassTwo.endsWith(' '))
            cls = @state.clas
            buttonDisabled = noMatch or whitespace or @state.informaticsError or @state.informaticsLoading or @state.codeforcesLoading or @state.codeforcesError
            <div>
                <h2>{LangRaw("edit_profile", @props.lang)}</h2>
                <form className = {styles.form}>
                    <div>
                        {LangRaw("old_password_required", @props.lang)}:
                            <Input
                                type = "password"
                                name = "password"
                                value =  {@state.password}
                                onChange = {@handlePasswordChange}
                                errors = {[@state.passError && LangRaw("wrong_password", @props.lang)]}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <h3>{LangRaw("change_password", @props.lang)}</h3>
                    <div>
                        {LangRaw("new_password", @props.lang)}:
                            <Input
                                type = "password"
                                name = "password"
                                value = {@state.newPassOne}
                                onChange = {@handleNewPassOneChange}
                                hideErrors = {true}
                                errors = {[noMatch && LangRaw("passwords_are_not_equal", @props.lang), 
                                    whitespace && LangRaw("password_can_not_start_with_space", @props.lang)]}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        {LangRaw("repeat_password", @props.lang)}:
                            <Input
                                type = "password"
                                name = "password"
                                value = {@state.newPassTwo}
                                onChange = {@handleNewPassTwoChange}
                                errors ={[noMatch && LangRaw("passwords_are_not_equal", @props.lang), 
                                    whitespace && LangRaw("password_can_not_start_with_space", @props.lang)]}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <h3>{LangRaw("profile_data", @props.lang)}</h3>
                    <div>
                        {LangRaw("new_name", @props.lang)}:
                            <Input
                                type = "text"
                                name = "newName"
                                value = {@state.newName}
                                onChange = {(@handleNewNameChange)}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        {LangRaw("codeforces_handle", @props.lang)}:
                            <Input
                                type = "text"
                                name = "newLogin"
                                value = {@state.cfLogin}
                                onChange = {@handleCfChange}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        {LangRaw("class", @props.lang)}:
                            <Input
                                type = "number"
                                name = "newClass"
                                value = {@state.clas}
                                onChange = {@handleClassChange}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        {LangRaw("informatics_password", @props.lang)}:
                            <Input
                                type = "password"
                                name = "InformsticsPassword"
                                value = {@state.informaticsPassword}
                                onChange = {@handleInformaticsPasswordChange}
                                onBlur = {@updateInformatics}
                                errors = {[@state.informaticsError && LangRaw("informatics_password_does_not_match_account", @props.lang)(@props.user._id)]}
                            />
                    </div>
                    <h3>{LangRaw("codeforces_data_for_submitting_problems", @props.lang)} </h3>
                    <div>
                        {LangRaw("codeforces_data_for_submitting_problems_intro", @props.lang)}
                        <br/>
                        {LangRaw("codeforces_data_for_submitting_problems_handle", @props.lang)}:
                            <Input
                                type = "text"
                                name = "codeforcesUsername"
                                value = {@state.codeforcesUsername}
                                onChange = {@handleCodeforcesUsernameChange}
                                onBlur = {@updateCodeforces}
                                errors = {[@state.codeforcesError && <div>{LangRaw("login_and_password_do_not_match", @props.lang)}</div>]}
                            />
                    </div>
                    <div>
                        Аккаунт в Телеграм (id или username):
                            <Input
                                type = "text"
                                name = "newTelegram"
                                value = {@state.newTelegram}
                                onChange = {@handleTelegramChange}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        {LangRaw("codeforces_data_for_submitting_problems_password", @props.lang)}:
                            <Input
                                type = "password"
                                name = "codeforcesPassword"
                                value = {@state.codeforcesPassword}
                                onChange = {@handleCodeforcesPasswordChange}
                                onBlur = {@updateCodeforces}
                                errors = {[@state.codeforcesError && <div>{LangRaw("login_and_password_do_not_match", @props.lang)}</div>]}
                            />
                    </div>
                    {@state.unknownError && <div className = {styles.youHaveProblem}></div>}
                </form>
                <Button onClick = {@submit} variant="light" bsSize = "small" disabled = {buttonDisabled}>OK</Button>
            </div>

options =
    urls: (props) ->
        registeredUser: "registeredUser/#{props.user._id}"

export default ConnectedComponent(withLang(EditingUser), options)
