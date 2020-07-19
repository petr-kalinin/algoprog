React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import UsersWithAchieve from '../components/UsersWithAchieve'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class UsersWithAchievePage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Пользователи с ачивкой", _id: "usersWithAchieve"},
        }
        child = <UsersWithAchieve users={@props.users} achieve={@props.match.params.achieve}/>
        `<Sceleton {...sceletonProps}>{child}</Sceleton>`

options =
    urls: (props) ->
        users: "users/withAchieve/#{props.match.params.achieve}"

export default ConnectedComponent(UsersWithAchievePage, options)