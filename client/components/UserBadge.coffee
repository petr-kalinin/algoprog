React = require('react')
deepcopy = require("deepcopy")
moment = require('moment')
deepEqual = require('deep-equal')

import Button from 'react-bootstrap/lib/Button'
import { Link } from 'react-router-dom'

import callApi from '../lib/callApi'

import CfStatus from './CfStatus'
import EditingUserForAdmin from './EditUserForAdmin'
import UserName from './UserName'
import {BigAchieves} from './Achieves'

import {getClassStartingFromJuly} from '../../client/lib/graduateYearToClass'

export default class UserBadge extends React.Component
    constructor: (props) ->
        super(props)

    render: () ->
        cls = getClassStartingFromJuly(@props.user.graduateYear)
        <div>
            <h1>
                <UserName user={@props.user} noachieves={true}/>
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
                {if +@props.user._id == @props.me?.informaticsId
                    <Link to="/edituser/#{@props.user._id}">Редактировать профиль</Link>}
            </blockquote>
            { @props.explain &&
                <a href = {"/user/" + @props.user._id} target = "_blank">Полные результаты</a> }
        </div>
