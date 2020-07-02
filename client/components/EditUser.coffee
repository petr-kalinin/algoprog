React = require('react')

import Button from 'react-bootstrap/lib/Button'
import Loader from '../components/Loader'

import CfStatus from './CfStatus'
import callApi from '../lib/callApi'

import styles from './EditUser.css'

import {getClassStartingFromJuly} from '../../client/lib/graduateYearToClass'

class Input extends React.Component
    constructor: (props) ->
        super(props)

    render: ()->
        err = false
        errors = @props.errors?.map(
            (val)->
                if val
                    <div className = "#{styles.youHaveProblem} alert-danger">{val}</div>
                    )
        if @props.errors? then err = true for q in errors when q
        <div className = {styles.divInput}>
            <input
                type = {@props.type}
                name = {@props.name}
                className = "#{styles.inp} #{err &&  styles.error}"
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

export default class EditingUser extends React.Component
    constructor: (props) ->
        super(props)
        @state = @startState(props)
        @handleNewNameChange = @handleNewNameChange.bind(this)
        @handleCfChange = @handleCfChange.bind(this)
        @handleClassChange = @handleClassChange.bind(this)
        @handleInformaticsPasswordChange = @handleInformaticsPasswordChange.bind(this)
        @updateInformatics = @updateInformatics.bind(this)
        @handleNewPassOneChange = @handleNewPassOneChange.bind(this)
        @handleNewPassTwoChange = @handleNewPassTwoChange.bind(this)
        @handlePasswordChange = @handlePasswordChange.bind(this)
        @submit = @submit.bind(this)
        @handleKeyPressed = @handleKeyPressed.bind(this)

    startState: (props) ->
        return
            cfLogin: props.user.cf?.login || ''
            password: ''
            clas: getClassStartingFromJuly(@props.user.graduateYear)
            newPassOne: ''
            newPassTwo: ''
            loading: false
            informaticsPassword: ''
            informaticsError: false
            informaticsLoading: false
            passError: false
            newName: ''
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

    submit: ()->
        try
            await @setState loading: true
            z = await callApi('user/' + @props.user._id + '/set',
                cf:
                    login: @state.cfLogin
                password: @state.password
                clas: @state.clas
                newPassword: @state.newPassOne
                informaticsPassword: @state.informaticsPassword
                informaticsUsername: @props.me.informaticsUsername
                newName: @state.newName
                )
            @props.handleReload()
            if (z.passError)
                await @setState passError: true
            else
                @props.reload()
            await @setState loading: false
        catch
            @setState unknownError: true

    handleCfChange: (event) ->
        await @setState cfLogin: event.target.value

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
            buttonDisabled = noMatch or whitespace or @state.informaticsError or @state.informaticsLoading
            <div>
                <form className = {styles.form}>
                    <div>
                        Новое имя
                            <Input
                                type = "text"
                                name = "newName"
                                value = {@state.newName}
                                onChange = {(@handleNewNameChange)}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        Логин на codeforces
                            <Input
                                type = "text"
                                name = "newLogin"
                                value = {@state.cfLogin}
                                onChange = {@handleCfChange}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        Класс
                            <Input
                                type = "number"
                                name = "newClass"
                                value = {@state.clas}
                                onChange = {@handleClassChange}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        Пароль от informatics
                            <Input
                                type = "password"
                                name = "InformsticsPassword"
                                value = {@state.informaticsPassword}
                                onChange = {@handleInformaticsPasswordChange}
                                onBlur = {@updateInformatics}
                                errors = {[@state.informaticsError && <div>Пароль не подходит к <a href="https://informatics.mccme.ru/user/view.php?id=#{@props.user._id}">вашему аккаунту на informatics</a></div>]}
                            />
                    </div>
                    <div>
                        Старый проль
                            <Input
                                type = "password"
                                name = "password"
                                value =  {@state.password}
                                onChange = {@handlePasswordChange}
                                errors = {[@state.passError && "Неправильный пароль"]}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        Новый пароль
                            <Input
                                type = "password"
                                name = "password"
                                value = {@state.newPassOne}
                                onChange = {@handleNewPassOneChange}
                                hideErrors = {true}
                                errors = {[noMatch && "Пароли не совпадают", whitespace && "Пароль не может начинаться с пробела или заканчиваться на него"]}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        Повторите пароль
                            <Input
                                type = "password"
                                name = "password"
                                value = {@state.newPassTwo}
                                onChange = {@handleNewPassTwoChange}
                                errors = {[noMatch && "Пароли не совпадают", whitespace && "Пароль не может начинаться с пробела или заканчиваться на него"]}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    {@state.unknownError && <div className = {styles.youHaveProblem}>Неизвестная ошибка, проверьте подключение к интернету и перезагрузите страницу</div>}
                </form>
                <Button onClick = {@submit} bsStyle = "primary" bsSize = "small" disabled = {buttonDisabled}>Ок</Button>
            </div>