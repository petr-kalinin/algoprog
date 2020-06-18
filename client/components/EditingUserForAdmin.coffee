React = require('react')
moment = require('moment')

import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'

import callApi from '../lib/callApi'

import styles from './EditingUser.css'

import { GROUPS } from '../lib/informaticsGroups'


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

export default class EditingUserForAdmin extends React.Component
    constructor: (props) ->
        super(props)
        @state = @startState(props)
        @handleKeyPressed = @handleKeyPressed.bind(this)
        @handleGraduateYearChange = @handleGraduateYearChange.bind(this)
        @handleSubmit = @handleSubmit.bind(this)
        @handleCfChange = @handleCfChange.bind(this)
        @handlePaidTillChange = @handlePaidTillChange.bind(this)
        @handlePriceChange = @handlePriceChange.bind(this)
        @handleAchievesChange = @handleAchievesChange.bind(this)
        @handlePasswordChange = @handlePasswordChange.bind(this)
        @updateResults = @updateResults.bind(this)
        

    startState: (props) ->
        return
            graduateYear: props.user.graduateYear || ''
            baseLevel: props.user.level.base || ''
            cfLogin: props.user.cf?.login || ''
            price: if props.user.price? then ''+props.user.price else ''
            achieves: (props.user.achieves || []).join(' ')
            password: ''

    handleSubmit: (event) ->
        await callApi('user/' + @props.user._id + '/setAdmin',
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
            
    handleKeyPressed: (e) ->
        if e.key == "Enter"
            @handleSubmit(e)        

    handleGraduateYearChange: (e) ->
        await @setState graduateYear: e.target.value

    handleBlChange: (e) ->
        await @setState baseLevel: e.target.value

    handleCfChange: (e) ->
        await @setState cfLogin:e.target.value

    handlePaidTillChange: (e) ->
        await @setState paidTill:e.target.value

    handlePriceChange: (e) ->
        await @setState price: e.target.value    

    handleAchievesChange: (e) ->
        await @setState achieves: e

    handlePasswordChange: (e) ->
        await @setState password: e   

    updateResults: (e) ->
        await callApi('updateResults/' + @props.user._id)
        @props.handleReload()     

    render: () ->
        <div>
            <form className = {styles.form} onSubmit = {@handleSubmit}>
                <div>
                    Год выпуска: <input
                        type = "text"
                        name = "newgraduateYear"
                        value = {@state.graduateYear}
                        size = "4"
                        onChange = {@handleGraduateYearChange}
                        onKeyPress = {@handleKeyPressed} />
                </div>
                <div>
                    Базовый уровень: <input
                        type = "text"
                        name = "newLevel"
                        value = {@state.baseLevel}
                        size = "3"
                        onChange = {@handleBlChange}
                        onKeyPress = {@handleKeyPressed} />
                </div>
                <div>
                    Cf login: <input
                        type = "text"
                        name = "newLogin"
                        value = {@state.cfLogin}
                        size = "20"
                        onChange = {@handleCfChange}
                        onKeyPress = {@handleKeyPressed} />
                </div>
                <div>
                    Paid till (YYYY-MM-DD): <input
                        type = "text"
                        name = "newPaidTill"
                        value = {@state.paidTill}
                        size = "20"
                        onChange = {@handlePaidTillChange}
                        onKeyPress = {@handleKeyPressed} />
                    {if @props.user.paidTill 
                        paidTill = moment(@props.user.paidTill).hours(23).minutes(59).seconds(59)
                        paidTillDate = paidTill.format("YYYY-MM-DD")
                        timeLeft = Math.floor(paidTill.diff(moment(), 'days', true))
                        " (на сервере: #{paidTillDate} = #{timeLeft} дней)"
                    }
                </div>
                <div>
                    Стоимость: <input
                        type = "text"
                        name = "newPrice"
                        value = {@state.price}
                        size = "20"
                        onChange = {@handlePriceChange}
                        onKeyPress = {@handleKeyPressed} />
                    {if @props.user.price?
                        " (на сервере: #{@props.user.price})"
                    }
                </div>
                <div>
                    Ачивки: <input
                        type = "text"
                        name = "achieves"
                        value = {@state.achieves}
                        size = "20"
                        onChange = {@handleAchievesChange}
                        onKeyPress = {@handleKeyPressed} />
                </div>
                <div>
                    Пароль: <input
                        type = "text"
                        name = "password"
                        value = {@state.password}
                        size = "20"
                        onChange = {@handlePasswordChange}
                        onKeyPress = {@handleKeyPressed} />
                </div>
                <GroupSelector user = {@props.user} handleReload = {@props.handleReload}/> 
                <Button onClick = {@updateResults}>Update results</Button>
            </form>
        </div>    