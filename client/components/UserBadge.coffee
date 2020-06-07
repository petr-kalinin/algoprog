React = require('react')
deepcopy = require("deepcopy")
moment = require('moment')
deepEqual = require('deep-equal')

import Button from 'react-bootstrap/lib/Button'

import callApi from '../lib/callApi'

import CfStatus from './CfStatus'
import EditingUser from './EditingUser'
import EditingUserForAdmin from './EditingUserForAdmin' 
import UserName from './UserName'
import {BigAchieves} from './Achieves'

import {getClassStartingFromJuly} from '../../client/lib/graduateYearToClass'
        
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
        @handleKeyPressed = @handleKeyPressed.bind(this)
        @updateResults = @updateResults.bind(this)
        @submit = @submit.bind(this)


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

    handleChange: (field, event) ->
        newState = deepcopy(@state)
        newState[field] = event.target.value
        @setState(newState)

    handleGraduateYearChange: (event) ->
        @handleChange("graduateYear", event)

    handleBlChange: (event) ->
        @handleChange("baseLevel", event)

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

    

    handleKeyPressed: (e) ->
        if e.key == "Enter"
            @handleSubmit(e)

    updateResults: (e) ->
        await callApi('updateResults/' + @props.user._id)
        @props.handleReload()

    submit: () ->  
        await @setState redact:!@state.redact 
        @props.handleReload()              

    render: () ->
        if(@state.redact)
            cls = getClassStartingFromJuly(@props.user.graduateYear)
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
                        <EditingUserForAdmin {...this.props}/>
                    }
                </blockquote>
                {+@props.user._id == @props.me?.informaticsId &&
                <Button bsStyle="primary" bsSize="small" onClick={@submit}>Редактировать профиль</Button>
                }
                { @props.explain &&
                    <a href={"/user/" + @props.user._id} target="_blank">Полные результаты</a> }
            </div>
        else  
            <EditingUser {...this.props} submit={@submit}/>
