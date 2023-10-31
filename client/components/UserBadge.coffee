React = require('react')
deepcopy = require("deepcopy")
moment = require('moment')
deepEqual = require('deep-equal')

import Button from 'react-bootstrap/lib/Button'
import { Link } from 'react-router-dom'

import {LangRaw} from '../lang/lang'

import callApi from '../lib/callApi'
import {getClassStartingFromJuly} from '../lib/graduateYearToClass'
import stripLabel from '../lib/stripLabel'
import withLang from '../lib/withLang'
import hasCapability, {SEE_START_LEVEL, EDIT_USER, hasCapabilityForUserList} from '../lib/adminCapabilities'


import {BigAchieves} from './Achieves'
import CfStatus from './CfStatus'
import EditingUserForAdmin from './EditUserForAdmin'
import TShirts from './TShirts'
import UserName from './UserName'


export default class UserBadge extends React.Component
    constructor: (props) ->
        super(props)

    render: () ->
        cls = getClassStartingFromJuly(@props.user.graduateYear)
        LANG = (id) => LangRaw(id, @props.lang)
        <div>
            <h1>
                <UserName user={@props.user} noachieves={true}/>
            </h1>
            <BigAchieves achieves = {@props.user.achieves} />
            <h2><TShirts user={@props.user} onClick={@props.onTShirtsClick}/></h2>
            <blockquote>
                {cls && <div>{LANG("class")}: {cls}</div>}
                <div>{LANG("level")}: {stripLabel(@props.user.level?.current)}</div>
                { hasCapabilityForUserList(@props.me, SEE_START_LEVEL, @props.user.userList) &&
                    <div>
                        Уровень на начало полугодия: {@props.user.level?.start}
                    </div> }
                <div>{LANG("rating")}: {@props.user.rating}</div>
                <div>{LANG("activity")}: {@props.user.activity.toFixed(1)}</div>
                {
                if @props.user.cf?.rating
                    <div>{LANG("codeforces_rating")}: <CfStatus cf = {@props.user.cf}/> </div>
                else if @props.explain
                        <div>{LANG("cf_login_unknown")}</div>
                }
                {hasCapabilityForUserList(@props.me, EDIT_USER, @props.user.userList) && <EditingUserForAdmin {...this.props}/>}
                {if +@props.user._id == @props.me?.informaticsId
                    <Link to="/edituser/#{@props.user._id}">{LANG("edit_profile")}</Link>}
            </blockquote>
            { @props.explain &&
                <a href = {"/user/" + @props.user._id} target = "_blank">{LANG("full_results")}</a> }
        </div>
