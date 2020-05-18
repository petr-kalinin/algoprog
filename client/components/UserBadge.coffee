React = require('react')
deepcopy = require("deepcopy")
moment = require('moment')
deepEqual = require('deep-equal')

import Grid from 'react-bootstrap/lib/Grid'
import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import Loader from '../components/Loader'

import callApi from '../lib/callApi'

import CfStatus from './CfStatus'
import UserName from './UserName'
import {BigAchieves} from './Achieves'

import styles from './UserBadge.css'

import { GROUPS } from '../lib/informaticsGroups'

import {getClassStartingFromJuly} from '../../client/lib/graduateYearToClass'

class GroupSelector extends React.Component
    constructor: (props) ->
        super(props)
        @handleMove = @handleMove.bind(this)
        @setDormant = @setDormant.bind(this)

    handleMove: (name) ->
        () =>
            await callApi "moveUserToGroup/#{@props.user._id}/#{name}", {}  # empty data to have it POSTed
            await @props.handleReload()
    
    setDormant: () ->
        () =>
            await callApi "setDormant/#{@props.user._id}", {}
            await @props.handleReload()

    render: () ->
        <div>
            {"Переместить в группу: "}
            <ButtonGroup>
                {
                res = []
                a = (el) -> res.push(el)
                for name, id of GROUPS
                    a <Button key={name} active={name==@props.user.userList} onClick={@handleMove(name)}>
                        {name}
                    </Button>
                a <Button key={"dormant"} active={@props.user.dormant} onClick={@setDormant()}>dormant</Button>
                res
                }
            </ButtonGroup>
        </div>
        

export default class UserBadge extends React.Component
    constructor: (props) ->
        super(props)
        @state = @startState(props)
        @handleChange = @handleChange.bind(this)
        @handleGraduateYearChange = @handleGraduateYearChange.bind(this)
        @handleBlChange = @handleBlChange.bind(this)
        @handleCfChange = @handleCfChange.bind(this)
        @handlePaidTillChange = @handlePaidTillChange.bind(this)
        @handlePriceChange = @handlePriceChange.bind(this)
        @handleAchievesChange = @handleAchievesChange.bind(this)
        @handlePasswordChange = @handlePasswordChange.bind(this)
        @handleSubmit = @handleSubmit.bind(this)
        @handleKeyPressed = @handleKeyPressed.bind(this)
        @updateResults = @updateResults.bind(this)
        @redactPan = @redactPan.bind(this)
        @onTab = @onTab.bind(this)
        @UserPeremen = @UserPeremen.bind(this)
        @handleClassChange = @handleClassChange.bind(this)
        @handleNewPassOneChange = @handleNewPassOneChange.bind(this)
        @handleNewPassTwoChange = @handleNewPassTwoChange.bind(this)
        @handleInformaticsPasswordChange = @handleInformaticsPasswordChange.bind(this)
        @InformOpdate=@InformOpdate.bind(this)
        @handlenewNameChange = @handlenewNameChange.bind(this)


    startState: (props) ->
        return
            graduateYear: props.user.graduateYear || '',
            baseLevel: props.user.level.base || '',
            cfLogin: props.user.cf?.login || '',
            paidTill: if props.user.paidTill then moment(props.user.paidTill).format("YYYY-MM-DD") else ''
            price: if props.user.price? then ''+props.user.price else ''
            achieves: (props.user.achieves || []).join(' ')
            password: ''
            redact: on
            NeSovpad:false
            Probel:false
            clas: getClassStartingFromJuly(@props.user.graduateYear)
            NewPassOne:''
            NewPassTwo:''
            loading:no
            PassProblem:no
            InformaticsPassword:''
            InformaticsProblem: no
            InformaticsLoading: no
            newName:''

    componentDidUpdate: (prevProps, prevState) ->
        newState = @startState(@props)
        oldStartState = @startState(prevProps)
        if !deepEqual(newState, oldStartState)
            @setState(newState)

    handleChange: (field, event) ->
        newState = deepcopy(@state)
        newState[field] = event.target.value
        @setState(newState)

    handleNewPassOneChange:(event)->
        await @handleChange("NewPassOne", event)
        if((@state.NewPassOne==@state.NewPassTwo)==@state.NeSovpad)
            @setState NeSovpad:!@state.NeSovpad
        if((@state.NewPassOne.startsWith(' ') or @state.NewPassTwo.startsWith(' ') or @state.NewPassOne.endsWith(' ') or @state.NewPassTwo.endsWith(' '))!= @state.Probel)
            @setState Probel:!@state.Probel

        
    handleNewPassTwoChange:(event)->
        await @handleChange("NewPassTwo", event)   
        if((@state.NewPassOne==@state.NewPassTwo)==@state.NeSovpad)
            @setState NeSovpad:!@state.NeSovpad
        if((@state.NewPassOne.startsWith(' ') or @state.NewPassTwo.startsWith(' ') or @state.NewPassOne.endsWith(' ') or @state.NewPassTwo.endsWith(' '))!= @state.Probel)
            @setState Probel:!@state.Probel



    handleGraduateYearChange: (event) ->
        @handleChange("graduateYear", event)

    handleClassChange: (event) ->
        @handleChange("clas", event) 

    handleBlChange: (event) ->
        @handleChange("baseLevel", event)

    handlenewNameChange: (event) ->
        @setState "newName": event.target.value

    handleCfChange: (event) ->
        @handleChange("cfLogin", event)

    handlePaidTillChange: (event) ->
        @handleChange("paidTill", event)

    handlePriceChange: (event) ->
        @handleChange("price", event)

    handleAchievesChange: (event) ->
        @handleChange("achieves", event)

    handlePasswordChange: (event) ->
        @handleChange("password", event)
        if(@state.PassProblem)
            @setState PassProblem:false       

    handleSubmit: (event) ->
        await callApi('user/' + @props.user._id + '/set',
            graduateYear: @state.graduateYear
            level:
                base: @state.baseLevel
            cf:
                login: @state.cfLogin
            paidTill: @state.paidTill
            price: @state.price
            achieves: @state.achieves
            password: @state.password
        )
        @props.handleReload()
        return

    handleInformaticsPasswordChange: (event) ->
        await @setState InformaticsPassword:event.target.value, InformaticsLoading:true

    InformOpdate:() ->    
        if(@state.InformaticsPassword!='')
            try
                data = await callApi "informatics/userData", {
                    username: @props.me.informaticsUsername,
                    password: @state.InformaticsPassword
                }
                if not ("name" of data)
                    throw "Can't find name"
                if(@state.InformaticsProblem)
                    @setState InformaticsProblem:no
            catch
                if(!@state.InformaticsProblem)
                    @setState InformaticsProblem:on
        else
            @setState InformaticsLoading:false       
        @setState InformaticsLoading:false    

    handleKeyPressed: (e) ->
        if e.key == "Enter"
            @handleSubmit(e)

    updateResults: (e) ->
        await callApi('updateResults/' + @props.user._id)
        @props.handleReload()

    UserPeremen: () ->
        z = await callApi('user/' + @props.user._id + '/setUser',
            cf:
                login: @state.cfLogin
            password: @state.password
            clas: @state.clas
            password: @state.password
            newPassword: @state.NewPassOne
            InformaticsPassword: @state.InformaticsPassword
            newName: @state.newName
            )
        @props.handleReload()
        return z

    onTab: () ->  
        if(!@state.redact)
            await @setState loading:true, PassProblem: false
            z =await @UserPeremen() 
            if(z.passProblem)
                await @setState PassProblem: true
            await @setState loading:false
        if  (!@state.PassProblem)    
            await @setState 
            redact:!@state.redact   
            password: ''
            redact: on
            NeSovpad:false
            Probel:false
            clas: getClassStartingFromJuly(@props.user.graduateYear)
            NewPassOne:''
            NewPassTwo:''
            loading:no
            PassProblem:no
            InformaticsPassword:''
            InformaticsProblem: no
            InformaticsLoading: no
            newName:''  

    redactPan: () ->
            if(@state.loading)
                <Loader/>
            else
                save = @state.NeSovpad or @state.Probel or @state.InformaticsProblem or @state.InformaticsLoading
                <div>
                    <h1>
                        <UserName user={@props.user} noachieves={true}/>
                    </h1>
                    <blockquote>
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
                            <form className={styles.form} onSubmit={@handleSubmit}>
                                <div>
                                    Новое имя
                                        <div className={styles.divInput}>
                                            <input
                                            type="text"
                                            name="newName"
                                            className={styles.inp}
                                            value={@state.newName}
                                            onChange={@handlenewNameChange}
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
                                            type="text"
                                            name="newgraduateYear"
                                            className={styles.inp}
                                            value={@state.clas}
                                            onChange={@handleClassChange}
                                            />
                                        </div>
                                </div>
                                <div>
                                    Пароль от informatics
                                        <div className={styles.divInput}>
                                            <input
                                            type="password"
                                            name="InformsticsPassword"
                                            className="#{styles.inp} #{@state.InformaticsProblem && styles.pr}" 
                                            value={@state.InformaticsPassword}
                                            onChange={@handleInformaticsPasswordChange} 
                                            onBlur = {@InformOpdate}
                                            />
                                            {@state.InformaticsProblem && <div className={styles.youHaveProblem}>Пароль не подходит к <a href="https://informatics.mccme.ru/user/view.php?id=#{@props.user._id}">вашему</a> аккаунту на informatics</div>}
                                        </div>
                                </div>
                                <div>
                                    Новый пароль
                                        <div className={styles.divInput}>
                                            <input
                                            type="password"
                                            name="password"
                                            className="#{styles.inp} #{(@state.NeSovpad or @state.Probel) && styles.pr}" 
                                            value={@state.NewPassOne}
                                            onChange={@handleNewPassOneChange}
                                            />
                                        </div>
                                </div>
                                <div>
                                    Повторите пароль
                                        <div className={styles.divInput}>
                                            <input
                                            type="password"
                                            name="password"
                                            className="#{styles.inp} #{(@state.NeSovpad or @state.Probel) && styles.pr}" 
                                            value={@state.NewPassTwo}
                                            onChange={@handleNewPassTwoChange}
                                            />
                                            {@state.NeSovpad && <div className={styles.youHaveProblem}>Пароли не совпадают</div>}
                                            {@state.Probel && <div className={styles.youHaveProblem}>Пароль не может начинаться с пробела или заканчиваться на него</div>}
                                        </div>
                                </div>
                                <div>
                                    Старый проль
                                        <div className={styles.divInput}>
                                            <input
                                            type="password"
                                            name="password"
                                            className="#{styles.inp} #{@state.PassProblem && styles.pr}" 
                                            value={@state.password}
                                            onChange={@handlePasswordChange}
                                            />
                                            {@state.PassProblem && <div className={styles.youHaveProblem}>Неправильный пароль</div>}
                                        </div>
                                </div>
                            </form> 
                        { @props.me?.admin && <GroupSelector user={@props.user} handleReload={@props.handleReload}/> }
                        { @props.me?.admin && <Button onClick={@updateResults}>Update results</Button> }
                    </blockquote>
                    { !@props.me?.admin && @props.user._id-0 == @props.me?.informaticsId &&
                    <Button onClick={@onTab} bsStyle="primary" bsSize="small" disabled={save}>Сохранить</Button>
                    }
                    { @props.explain &&
                        <a href={"/user/" + @props.user._id} target="_blank">Полные результаты</a> }
                </div> 

            

    render: () ->
        if(@state.redact)
            cls = @state.clas
            <div>
                <h1>
                    <UserName user={@props.user} noachieves={true}/>
                </h1>
                <BigAchieves achieves={@props.user.achieves} />
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
                    

                    { @props.me?.admin &&
                        <form className={styles.form} onSubmit={@handleSubmit}>
                            <div>
                                Год выпуска: <input
                                    type="text"
                                    name="newgraduateYear"
                                    value={@state.graduateYear}
                                    size="4"
                                    onChange={@handleGraduateYearChange}
                                    onKeyPress={@handleKeyPressed} />
                            </div>
                            <div>
                                Базовый уровень: <input
                                    type="text"
                                    name="newLevel"
                                    value={@state.baseLevel}
                                    size="3"
                                    onChange={@handleBlChange}
                                    onKeyPress={@handleKeyPressed} />
                            </div>
                            <div>
                                Cf login: <input
                                    type="text"
                                    name="newLogin"
                                    value={@state.cfLogin}
                                    size="20"
                                    onChange={@handleCfChange}
                                    onKeyPress={@handleKeyPressed} />
                            </div>
                            <div>
                                Paid till (YYYY-MM-DD): <input
                                    type="text"
                                    name="newPaidTill"
                                    value={@state.paidTill}
                                    size="20"
                                    onChange={@handlePaidTillChange}
                                    onKeyPress={@handleKeyPressed} />
                                {if @props.user.paidTill 
                                    paidTill = moment(@props.user.paidTill).hours(23).minutes(59).seconds(59)
                                    paidTillDate = paidTill.format("YYYY-MM-DD")
                                    timeLeft = Math.floor(paidTill.diff(moment(), 'days', true))
                                    " (на сервере: #{paidTillDate} = #{timeLeft} дней)"
                                }
                            </div>
                            <div>
                                Стоимость: <input
                                    type="text"
                                    name="newPrice"
                                    value={@state.price}
                                    size="20"
                                    onChange={@handlePriceChange}
                                    onKeyPress={@handleKeyPressed} />
                                {if @props.user.price?
                                    " (на сервере: #{@props.user.price})"
                                }
                            </div>
                            <div>
                                Ачивки: <input
                                    type="text"
                                    name="achieves"
                                    value={@state.achieves}
                                    size="20"
                                    onChange={@handleAchievesChange}
                                    onKeyPress={@handleKeyPressed} />
                            </div>
                            <div>
                                Пароль: <input
                                    type="text"
                                    name="password"
                                    value={@state.password}
                                    size="20"
                                    onChange={@handlePasswordChange}
                                    onKeyPress={@handleKeyPressed} />
                            </div>
                        </form> }
                    { @props.me?.admin && <GroupSelector user={@props.user} handleReload={@props.handleReload}/> }
                    { @props.me?.admin && <Button onClick={@updateResults}>Update results</Button> }
                </blockquote>
                { !@props.me?.admin && @props.user._id-0 == @props.me?.informaticsId &&
                <Button bsStyle="primary" bsSize="small" onClick={@onTab}>Редактировать профиль</Button>
                }
                { @props.explain &&
                    <a href={"/user/" + @props.user._id} target="_blank">Полные результаты</a> }
            </div>
        else  
            @redactPan() 
