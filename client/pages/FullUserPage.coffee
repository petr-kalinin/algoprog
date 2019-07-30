React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FullUser from '../components/FullUser'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class FullUserPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: @props.data.user?.name, _id: "user" + @props.data.user?._id},
            showNews: "hide",
            showTree: "hide"
        }
        child = <FullUser user={@props.data.user} me={@props.me} results={@props.data.results} handleReload={@props.handleReload}/>
        `<Sceleton {...sceletonProps}>{child}</Sceleton>`

options =
    urls: (props) ->
        data: "fullUser/#{props.match.params.id}"
        me: "me"

export default ConnectedComponent(FullUserPage, options)
