React = require('react')
deepcopy = require("deepcopy")

import { Grid } from 'react-bootstrap'

import callApi from '../lib/callApi'

import CfStatus from './CfStatus'
import UserName from './UserName'

import styles from './UserBadge.css'


export default class UserBadge extends React.Component 
    constructor: (props) ->
        super(props)
        @state = 
            baseLevel: props.user.level.base || '',
            cfLogin: @props.user.cf?.login || ''
        @handleChange = @handleChange.bind(this)
        @handleBlChange = @handleBlChange.bind(this)
        @handleCfChange = @handleCfChange.bind(this)
        @handleSubmit = @handleSubmit.bind(this)
        @handleKeyPressed = @handleKeyPressed.bind(this)
        
    handleChange: (field, event) ->
        newState = deepcopy(@state)
        newState[field] = event.target.value
        @setState(newState)
        
    handleBlChange: (event) ->
        @handleChange("baseLevel", event)

    handleCfChange: (event) ->
        @handleChange("cfLogin", event)
        
    handleSubmit: (event) ->
        await callApi('user/' + @props.user._id + '/set', 
            level:
                base: @state.baseLevel
            cf:
                login: @state.cfLogin
        )
        @props.handleReload()

    handleKeyPressed: (e) ->
        if e.key == "Enter"
            @handleSubmit(e)
    
    render: () ->
        <div>
            <h1>
                <UserName user={@props.user}/>
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
                    <div>Логин на codeforces неизвестен. Если вы зарегистированы, сообщите логин мне.</div>
                }
                
                { @props.me?.admin && 
                    <form className={styles.form} onSubmit={@handleSubmit}>
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
                    </form> }
            </blockquote>
            { @props.explain &&
                <a href={"/user/" + @props.user._id} target="_blank">Полные результаты</a> }
        </div>
