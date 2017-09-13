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

    url: ->
        return "fullUser/#{@props.match.params.id}"

    render:  () ->
        if @props.dataUrl != @url()
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

    requestData: () ->
        return [@props.getMe(), @props.getData(@url())]

mapStateToProps = (state, ownProps) ->
    return
        me: state.me
        dataUrl: state.data.url
        user: state.data.data?.user
        results: state.data.data?.results

mapDispatchToProps = (dispatch, ownProps) ->
    return
        getMe: () -> dispatch(actions.getMe())
        getData: (url) -> dispatch(actions.getData(url))
        saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))

export default FullUserPageConnected = connect(
    mapStateToProps,
    mapDispatchToProps
)(FullUserPage)
