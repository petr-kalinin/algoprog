React = require('react')
import { withRouter } from 'react-router'
import { connect } from 'react-redux'

import Grid from 'react-bootstrap/lib/Grid'
import Form from 'react-bootstrap/lib/Form'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import HelpBlock from 'react-bootstrap/lib/HelpBlock'
import Button from 'react-bootstrap/lib/Button'

import { Redirect } from 'react-router-dom'

import Loader from '../components/Loader'

import callApi from '../lib/callApi'
import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

import FieldGroup from './FieldGroup'

import * as actions from '../redux/actions'

class LoginAsTeam extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            team: @props.teams[0]._id
        @setField = @setField.bind(this)
        @tryLogin = @tryLogin.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    tryLogin: (event) ->
        event.preventDefault()
        newState = {
            @state...
            loading: true
        }
        @setState(newState)
        try
            data = await callApi "loginAsTeam", {
                team: @state.team
            }
            if not data.logged
                throw "Error"
            @props.reloadMyData()
            @props.history.goBack()
        catch
            data =
                error: true
                message: "Неопознанная ошибка"
            newState = {
                @state...,
                loading: false,
                data...
            }
            @setState(newState)


    render:  () ->
        canSubmit = @state.team && !@state.loading
        <Grid fluid>
            <h1>Войти как команда</h1>

            <form onSubmit={@tryLogin} autoComplete="off">
                {
                if not @state.loading
                    <div>
                        <FieldGroup
                            id="team"
                            label="Команда"
                            componentClass="select"
                            setField={@setField}
                            state={@state}
                            validationState={@state.error && 'error'}>
                            {@props.teams.map((team) =>
                                <option value={team._id} key={team._id}>{team.name}</option>
                            )}
                        </FieldGroup>
                    </div>
                else
                    <Loader/>
                }
                {
                @state.message &&
                <FormGroup>
                    <FormControl.Static>
                        {@state.message}
                    </FormControl.Static>
                </FormGroup>
                }
                <Button type="submit" bsStyle="primary" disabled={!canSubmit}>
                    Войти
                </Button>
            </form>
        </Grid>

teamOptions =
    urls: (props) ->
        if not props.myUser
            return {}
        teams: "userTeams/#{props.myUser._id}"

LoginAsTeam = ConnectedComponent(LoginAsTeam, teamOptions)

mapStateToProps = () ->
    {}

mapDispatchToProps = (dispatch) ->
    return
        reloadMyData: () -> dispatch(actions.invalidateAllData())

export default withMyUser(withRouter(connect(mapStateToProps, mapDispatchToProps)(LoginAsTeam)))
