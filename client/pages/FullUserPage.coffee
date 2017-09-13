React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"
import { connect } from 'react-redux'

import { CometSpinLoader } from 'react-css-loaders';

import FullUser from '../components/FullUser'

import * as actions from '../redux/actions'

class FullUserPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        if not @props?.user?.name
            return
                <CometSpinLoader />
        return
            <Grid fluid>
                <Helmet>
                    <title>{@props.user.name}</title>
                </Helmet>
                <FullUser user={@props.user} me={@props.me} results={@props.results} handleReload={@handleReload}/>
            </Grid>

    componentWillMount: ->
        promises = @requestData()
        if not window?
            @props.saveDataPromises(promises)

    @loadData: () ->
        undefined

    requestData: () ->
        return [@props.getMe(), @props.getUser()]

mapStateToProps = (state, ownProps) ->
    return
        me: state.me
        user: state.users[ownProps.match.params.id]?.user
        results: state.users[ownProps.match.params.id]?.results

mapDispatchToProps = (dispatch, ownProps) ->
    return
        getMe: () -> dispatch(actions.getMe())
        getUser: () -> dispatch(actions.getFullUser(ownProps.match.params.id))
        saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))

export default FullUserPageConnected = connect(
    mapStateToProps,
    mapDispatchToProps
)(FullUserPage)
