React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FullUser from '../components/FullUser'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from './ConnectedComponent'

class FullUserPage extends React.Component
    constructor: (props) ->
        super(props)

    @url: (props) ->
        return "fullUser/#{props.match.params.id}"

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: @props.data.user.name, _id: "user" + @props.data.user._id},
            showNews: "hide",
            showTree: "hide"
        }
        child = <FullUser user={@props.data.user} me={@props.me} results={@props.data.results} handleReload={@props.handleReload}/>
        `<Sceleton {...sceletonProps}>{child}</Sceleton>`

export default ConnectedComponent(FullUserPage)
