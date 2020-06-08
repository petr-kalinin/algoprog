React = require('react')

import UserName from './UserName'
import Button from 'react-bootstrap/lib/Button'
import Loader from '../components/Loader'

import CfStatus from './CfStatus'
import callApi from '../lib/callApi'

import styles from './EditingUser.css'

import {getClassStartingFromJuly} from '../../client/lib/graduateYearToClass'

class MeInput extends React.Component
    constructor: (props) ->
        super(props)

    render:()-> 
            <div className={styles.divInput}>
                <input
                    type= {@props.type}
                    name= {@props.name}
                    className="#{styles.inp} #{@props.error && styles.error}"
                    value= {@props.value}
                    onChange= {@props.onChange}
                    onBlur = {@props.onBlur}
                />
                {@props.oneError && <div className={styles.youHaveProblem}>{@props.oneError}</div>}
                {@props.twoError && <div className={styles.youHaveProblem}>{@props.twoError}</div>}
            </div>

export default class EditingUser extends React.Component
    constructor: (props) ->
        super(props)
        @state = @startState(props)
        @handleNewNameChange = @handleNewNameChange.bind(this)
        @handleCfChange= @handleCfChange.bind(this)
        @handleClassChange = @handleClassChange.bind(this)
        @handleInformaticsPasswordChange = @handleInformaticsPasswordChange.bind(this)
        @informOpdate = @informOpdate.bind(this)
        @handleNewPassOneChange = @handleNewPassOneChange.bind(this)
        @handleNewPassTwoChange = @handleNewPassTwoChange.bind(this)
        @handlePasswordChange = @handlePasswordChange.bind(this)
        @press = @press.bind(this)

    startState: (props) ->
        return
            cfLogin: props.user.cf?.login || ''
            password: ''
            clas: getClassStartingFromJuly(@props.user.graduateYear)
            newPassOne:''
            newPassTwo:''
            loading:no
            informaticsPassword:''
            informaticsError: no
            informaticsLoading: no
            passError:no
            newName:''
            unknownError: no

    informOpdate:()->
        await @setState informaticsLoading:on
        if(@state.informaticsPassword!='')
            try
                data = await callApi "informatics/userData", {
                    username: @props.me.informaticsUsername,
                    password: @state.informaticsPassword
                }
                if not ("name" of data)
                    throw "Can't find name"
                if(@state.informaticsError)
                    await @setState informaticsError:no
            catch
                if(!@state.informaticsError)
                    await @setState informaticsError:on  
        else
            if(@state.informaticsError)
                await @setState informaticsError:no            
        await @setState informaticsLoading:no  

    press:()->
        try
            await @setState loading:true
            z = await callApi('user/' + @props.user._id + '/set',
                cf:
                    login: @state.cfLogin
                password: @state.password
                clas: @state.clas
                newPassword: @state.newPassOne
                InformaticsPassword: @state.informaticsPassword
                newName: @state.newName
                )
            @props.handleReload()
            if(z.passError)
                await @setState passError:on
            else
                @props.submit()    
            await @setState loading:false      
        catch    
            @setState unknownError: on

    handleCfChange:(event) ->
        await @setState cfLogin: event.target.value

    handlePasswordChange:(event) ->
        await @setState password: event.target.value, passError: no

    handleNewPassTwoChange:(event)->
        await @setState newPassTwo: event.target.value 

    handleNewPassOneChange:(event)->
        await @setState newPassOne: event.target.value

    handleClassChange:(event)->
        await @setState clas: event.target.value

    handleNewNameChange:(event)->
        await @setState newName: event.target.value

    handleInformaticsPasswordChange:(event)->
        await @setState informaticsPassword: event.target.value    

    render: () ->
        if @state.loading
            <Loader />
        else
            noMatch = (@state.newPassOne!=@state.newPassTwo)
            whitespace = (@state.newPassOne.startsWith(' ') or @state.newPassTwo.startsWith(' ') or @state.newPassOne.endsWith(' ') or @state.newPassTwo.endsWith(' '))
            cls = @state.clas
            battonSave = noMatch or whitespace or @state.informaticsError or @state.informaticsLoading
            <div>
                <h1>
                    <UserName user={@props.user} noachieves={true}/>
                </h1>
                <blockquote>
                    {cls && <div>Класс: {cls}</div>}
                    <div>Уровень: {@props.user.level.current}</div>
                    { @props.me?.admin &&
                        <div>
                            Уровень на начало полугодия: {@props.user.level.start}
                        </div> }
                    <div>Рейтинг: {@props.user.rating}</div>
                    <div>Активность: {@props.user.activity.toFixed(1)}</div>
                    {
                    if @props.user.cf?.rating
                        <div> Codeforces рейтинг: <CfStatus cf={@props.user.cf}/> </div>
                    else if @props.explain
                        <div>Логин на codeforces неизвестен. Если вы там зарегистированы, укажите логин в своём профиле.</div>
                    }
                    <form className={styles.form}>
                        <div>
                            Новое имя
                                <div className={styles.divInput}>
                                    <input
                                        type="text"
                                        name="newName"
                                        className={styles.inp}
                                        value={@state.newName}
                                        onChange={(@handleNewNameChange)}
                                    />
                                </div>
                        </div>
                        <div>
                            Логин на codeforces
                                <div className={styles.divInput}>
                                    <input
                                        type="text"
                                        name="newLogin"
                                        className={styles.inp}
                                        value={@state.cfLogin}
                                        onChange={@handleCfChange}
                                    />
                                </div>
                        </div>
                        <div>
                            Класс
                                <div className={styles.divInput}>
                                    <input
                                        type="number"
                                        name="newgraduateYear"
                                        className={styles.inp}
                                        value={@state.clas}
                                        onChange={@handleClassChange}
                                    />
                                </div>
                        </div>
                        <div>
                            Пароль от informatics
                                <MeInput
                                    type="password"
                                    name="InformsticsPassword"
                                    error = {@state.informaticsError}
                                    value={@state.informaticsPassword}
                                    onChange={@handleInformaticsPasswordChange} 
                                    onBlur = {@informOpdate}  
                                    oneError = {@state.informaticsError && <div>Пароль не подходит к <a href="https://informatics.mccme.ru/user/view.php?id=#{@props.user._id}">вашему</a> аккаунту на informatics</div>}  
                                    twoError= {false} 
                                />
                        </div>
                        <div>
                            Новый пароль
                                <div className={styles.divInput}>
                                    <input
                                        type="password"
                                        name="password"
                                        className="#{styles.inp} #{(noMatch or whitespace) && styles.error}" 
                                        value={@state.newPassOne}
                                        onChange={@handleNewPassOneChange}
                                    />
                                </div>
                        </div>
                        <div>
                            Повторите пароль
                                <MeInput
                                    type="password"
                                    name="password"
                                    error = {noMatch or whitespace}
                                    value={@state.newPassTwo}
                                    onChange={@handleNewPassTwoChange}
                                    oneError = {noMatch && <div>Пароли не совпадают</div>}
                                    twoError = {whitespace && <div>Пароль не может начинаться с пробела или заканчиваться на него</div>}
                                />
                        </div>
                        <div>
                            Старый проль
                                <MeInput
                                    type="password"
                                    name="password"
                                    error={@state.passError}
                                    value={@state.password}
                                    onChange={@handlePasswordChange}
                                    oneError = {@state.passError && <div>Неправильный пароль</div>}
                                    twoError = {false}
                                />
                        </div>
                        {@state.unknownError && <div className={styles.youHaveProblem}>Неизвестная ошибка, проверьте подключение к интернету и перезагрузите страницу</div>}
                    </form> 
                </blockquote>
                <Button onClick={@press} bsStyle="primary" bsSize="small" disabled={battonSave}> Сохранить</Button>
            </div> 