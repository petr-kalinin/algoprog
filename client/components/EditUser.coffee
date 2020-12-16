React = require('react')

import Button from 'react-bootstrap/lib/Button'

import CfStatus from './CfStatus'
import styles from './EditUser.css'
import Loader from './Loader'

import callApi from '../lib/callApi'
import ConnectedComponent from '../lib/ConnectedComponent'
import {getClassStartingFromJuly} from '../lib/graduateYearToClass'

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
                <h2>Редактировать профиль</h2>
                <form className = {styles.form}>
                    <div>
                        Старый пароль (обязательно):
                            <Input
                                type = "password"
                                name = "password"
                                value =  {@state.password}
                                onChange = {@handlePasswordChange}
                                errors = {[@state.passError && "Неправильный пароль"]}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <h3>Сменить пароль</h3>
                    <div>
                        Новый пароль:
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
                        Повторите пароль:
                            <Input
                                type = "password"
                                name = "password"
                                value = {@state.newPassTwo}
                                onChange = {@handleNewPassTwoChange}
                                errors = {[noMatch && "Пароли не совпадают", whitespace && "Пароль не может начинаться с пробела или заканчиваться на него"]}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <h3>Данные профиля</h3>
                    <div>
                        Новое имя:
                            <Input
                                type = "text"
                                name = "newName"
                                value = {@state.newName}
                                onChange = {(@handleNewNameChange)}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        Хендл (никнейм) на codeforces:
                            <Input
                                type = "text"
                                name = "newLogin"
                                value = {@state.cfLogin}
                                onChange = {@handleCfChange}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        Класс:
                            <Input
                                type = "number"
                                name = "newClass"
                                value = {@state.clas}
                                onChange = {@handleClassChange}
                                onKeyPress={@handleKeyPressed}
                            />
                    </div>
                    <div>
                        Пароль от informatics:
                            <Input
                                type = "password"
                                name = "InformsticsPassword"
                                value = {@state.informaticsPassword}
                                onChange = {@handleInformaticsPasswordChange}
                                onBlur = {@updateInformatics}
                                errors = {[@state.informaticsError && <div>Пароль не подходит к <a href="https://informatics.mccme.ru/user/view.php?id=#{@props.user._id}">вашему аккаунту на informatics</a></div>]}
                            />
                    </div>
                    <h3>Данные codeforces для отправки решений </h3>
                    <div>
                        Некоторые задачи отправляются на codeforces, а не на информатикс. 
                        Для их отправки нужны логин и пароль от какого-нибудь вашего аккаунта на cf.
                        Вы можете указать данные того же аккаунта, что и выше, или можете зарегистрировать
                        отдельный аккаунт только для отправки решений с алгопрога, если не хотите указывать пароль
                        от вашего основного аккаунта.<br/>
                        Хендл (никнейм) на codeforces для отправки решений:
                            <Input
                                type = "text"
                                name = "codeforcesUsername"
                                value = {@state.codeforcesUsername}
                                onChange = {@handleCodeforcesUsernameChange}
                                onBlur = {@updateCodeforces}
                                errors = {[@state.codeforcesError && <div>Пароль не подходит к логину</div>]}
                            />
                    </div>
                    <div>
                        Пароль на codeforces для отправки решений:
                            <Input
                                type = "password"
                                name = "codeforcesPassword"
                                value = {@state.codeforcesPassword}
                                onChange = {@handleCodeforcesPasswordChange}
                                onBlur = {@updateCodeforces}
                                errors = {[@state.codeforcesError && <div>Пароль не подходит к логину</div>]}
                            />
                    </div>
                    {@state.unknownError && <div className = {styles.youHaveProblem}>Неизвестная ошибка, проверьте подключение к интернету и перезагрузите страницу</div>}
                </form>
                <Button onClick = {@submit} variant="light" bsSize = "small" disabled = {buttonDisabled}>Ок</Button>
            </div>

options =
    urls: (props) ->
        registeredUser: "registeredUser/#{props.user._id}"

export default ConnectedComponent(EditingUser, options)
