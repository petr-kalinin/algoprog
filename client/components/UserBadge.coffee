React = require('react')
$ = require('jquery');

import { Grid } from 'react-bootstrap'

import CfStatus from './CfStatus'
import UserName from './UserName'

export default class UserBadge extends React.Component 
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
                <h1>
                    <UserName user={@state}/>
                </h1>
                <blockquote>
                    <div>Уровень: {@state.level.current}</div>
                    <div>Рейтинг: {@state.rating}</div>
                    <div>Активность: {@state.activity}</div>
                    { @state.cf?.login && 
                        <div> Codeforces рейтинг: <CfStatus cf={@state.cf}/> </div> }
                </blockquote>
            </Grid>

    componentDidMount: ->
        $.ajax('/api/user/' + @id).done(((data) ->
            this.setState(data);
        ).bind(this))
            
            
