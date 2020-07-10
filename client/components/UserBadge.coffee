React = require('react')
deepcopy = require("deepcopy")
moment = require('moment')
deepEqual = require('deep-equal')

import Button from 'react-bootstrap/lib/Button'

import callApi from '../lib/callApi'

import CfStatus from './CfStatus'
import EditingUser from './EditUser'
import EditingUserForAdmin from './EditUserForAdmin'
import UserName from './UserName'
import {BigAchieves} from './Achieves'

import {getClassStartingFromJuly} from '../../client/lib/graduateYearToClass'

export default class UserBadge extends React.Component
    constructor: (props) ->
        super(props)
        @state = @startState(props)
        @reload = @reload.bind(this)


    startState: (props) ->
        return
            editing: true

    reload: () ->
        await @setState editing:!@state.editing
        @props.handleReload()

    render: () ->
        cls = getClassStartingFromJuly(@props.user.graduateYear)
        <div>
            <h1>
                <UserName user = {@props.user} noachieves={true}/>
            </h1>
            <BigAchieves achieves = {@props.user.achieves} />
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
                    <div> Codeforces рейтинг: <CfStatus cf = {@props.user.cf}/> </div>
                else if @props.explain
                        <div>Логин на codeforces неизвестен. Если вы там зарегистированы, укажите логин в своём профиле.</div>
                }
                {@props.me?.admin && <EditingUserForAdmin {...this.props}/>}
                {if(!@state.editing)
                    <div>
                        {+@props.user._id == @props.me?.informaticsId && <EditingUser {...this.props} reload = {@reload}/>}
                    </div>
                else
                    if (+@props.user._id == @props.me?.informaticsId || @props.me?.admin)
                        <Button variant="light" bsSize="small" onClick = {@reload}>Редактировать профиль</Button>}
            </blockquote>
            { @props.explain &&
                <a href = {"/user/" + @props.user._id} target = "_blank">Полные результаты</a> }
        </div>
