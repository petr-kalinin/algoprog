React = require('react')
deepcopy = require("deepcopy")
moment = require('moment')
deepEqual = require('deep-equal')

import Grid from 'react-bootstrap/lib/Grid'
import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'

import callApi from '../lib/callApi'

import CfStatus from './CfStatus'
import UserName from './UserName'

import styles from './UserBadge.css'

import { GROUPS } from '../lib/informaticsGroups'

class GroupSelector extends React.Component
    constructor: (props) ->
        super(props)
        @handleMove = @handleMove.bind(this)

    handleMove: (name) ->
        () =>
            await callApi "moveUserToGroup/#{@props.user._id}/#{name}", {}  # empty data to have it POSTed
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
                a <Button key={"none"} onClick={@handleMove("none")}>—</Button>
                res
                }
            </ButtonGroup>
        </div>

export default class UserBadge extends React.Component
    constructor: (props) ->
        super(props)
        @state = @startState(props)
        @handleChange = @handleChange.bind(this)
        @handleBlChange = @handleBlChange.bind(this)
        @handleCfChange = @handleCfChange.bind(this)
        @handlePaidTillChange = @handlePaidTillChange.bind(this)
        @handleSubmit = @handleSubmit.bind(this)
        @handleKeyPressed = @handleKeyPressed.bind(this)

    startState: (props) ->
        return
            baseLevel: props.user.level.base || '',
            cfLogin: props.user.cf?.login || '',
            paidTill: if props.user.paidTill then moment(props.user.paidTill).format("YYYY-MM-DD") else ''

    componentDidUpdate: (prevProps, prevState) ->
        newState = @startState(@props)
        oldStartState = @startState(prevProps)
        if !deepEqual(newState, oldStartState)
            @setState(newState)

    handleChange: (field, event) ->
        newState = deepcopy(@state)
        newState[field] = event.target.value
        @setState(newState)

    handleBlChange: (event) ->
        @handleChange("baseLevel", event)

    handleCfChange: (event) ->
        @handleChange("cfLogin", event)

    handlePaidTillChange: (event) ->
        @handleChange("paidTill", event)

    handleSubmit: (event) ->
        await callApi('user/' + @props.user._id + '/set',
            level:
                base: @state.baseLevel
            cf:
                login: @state.cfLogin
            paidTill: @state.paidTill
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
                { @props.me?.admin &&
                    <div>
                        Уровень на начало полугодия: {@props.user.level.start}
                    </div> }
                <div>Суммарный балл: {@props.user.points}</div>

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
                        <div>
                            Paid till (YYYY-MM-DD): <input
                                type="text"
                                name="newPaidTill"
                                value={@state.paidTill}
                                size="20"
                                onChange={@handlePaidTillChange}
                                onKeyPress={@handleKeyPressed} />
                            {" (сейчас: "}{if @props.user.paidTill then moment(@props.user.paidTill).format("YYYY-MM-DD")})
                        </div>
                    </form> }
                { @props.me?.admin && <GroupSelector user={@props.user} handleReload={@props.handleReload}/> }
            </blockquote>
            { @props.explain &&
                <a href={"/user/" + @props.user._id} target="_blank">Полные результаты</a> }
        </div>
