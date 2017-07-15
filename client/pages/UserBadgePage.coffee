React = require('react')
$ = require('jquery');

import { Grid } from 'react-bootstrap'
import UserBadge from '../components/UserBadge'

export default class UserBadgePage extends React.Component 
    constructor: (props) ->
        super(props)
        @id = props.match.params.id
        @state = {}
        
    render:  () ->
        if not @state?.name
            return
                <Grid fluid>
                </Grid>
        return 
            <Grid fluid>
                <UserBadge user={@state}/>
            </Grid>

    componentDidMount: ->
        $.ajax('/api/user/' + @id).done(((data) ->
            this.setState(data);
        ).bind(this))
            
            

