React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import EditUser from '../components/EditUser'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class EditUserPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: @props.data.user.name, _id: "user" + @props.data.user._id},
            showNews: "hide",
            showTree: "hide"
        }
        child = <EditUser user={@props.data.user} me={@props.me} results={@props.data.results} calendar={@props.data.calendar} handleReload={@props.handleReload}/>
        `<Sceleton {...sceletonProps}>{child}</Sceleton>`

options =
    urls: (props) ->
        data: "fullUser/#{props.match.params.id}"
        me: "me"

export default ConnectedComponent(EditUserPage, options)
