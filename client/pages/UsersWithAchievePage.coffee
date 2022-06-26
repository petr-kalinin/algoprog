React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import UsersWithAchieve from '../components/UsersWithAchieve'
import Sceleton from '../components/Sceleton'

import {LangRaw} from '../lang/lang'
import ConnectedComponent from '../lib/ConnectedComponent'
import withLang from '../lib/withLang'

class UsersWithAchievePage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: LangRaw("users_with_achieve", @props.lang), _id: "usersWithAchieve"},
        }
        child = <UsersWithAchieve users={@props.users} achieve={@props.match.params.achieve}/>
        `<Sceleton {...sceletonProps}>{child}</Sceleton>`

options =
    urls: (props) ->
        users: "users/withAchieve/#{props.match.params.achieve}"

export default ConnectedComponent(withLang(UsersWithAchievePage), options)