React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FullUser from '../components/FullUser'
import ConnectedComponent from './ConnectedComponent'

class FullUserPage extends React.Component
    constructor: (props) ->
        super(props)

    @url: (params) ->
        return "fullUser/#{params.id}"

    render:  () ->
        <Grid fluid>
            <Helmet>
                <title>{@props.data.user.name}</title>
            </Helmet>
            <FullUser user={@props.data.user} me={@props.me} results={@props.data.results} handleReload={@props.handleReload}/>
        </Grid>

export default ConnectedComponent(FullUserPage)
