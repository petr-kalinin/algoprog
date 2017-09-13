React = require('react')
import fetch from 'isomorphic-fetch'
import { connect } from 'react-redux'

import { CometSpinLoader } from 'react-css-loaders';

import { Helmet } from "react-helmet"

import { Grid } from 'react-bootstrap'

import Material from '../components/Material'
import callApi from '../lib/callApi'

import * as actions from '../redux/actions'

class MaterialPage extends React.Component
    constructor: (props) ->
        super(props)

    url: ->
        return "material/#{@props.match.params.id}"

    render:  () ->
        if @props.dataUrl != @url()
            return
                <CometSpinLoader />
        return
            <Grid fluid>
                <Helmet>
                    {@props.material?.title && <title>{@props.material.title}</title>}
                </Helmet>
                {@props.material && `<Material {...this.props}/>`}
            </Grid>

    componentWillMount: ->
        promises = @requestData()
        if not window?
            @props.saveDataPromises(promises)

    componentDidUpdate: (prevProps, prevState) ->
        if (prevProps.match.params.id != @props.match.params.id)
            @requestData()

    requestData: () ->
        return [@props.getMe(), @props.getData(@url()), @props.getTree(), @props.getNews()]


mapStateToProps = (state, ownProps) ->
    return
        me: state.me
        tree: state.tree
        news: state.news
        dataUrl: state.data.url
        material: state.data.data

mapDispatchToProps = (dispatch, ownProps) ->
    return
        getMe: () -> dispatch(actions.getMe())
        getTree: () -> dispatch(actions.getTree())
        getNews: () -> dispatch(actions.getNews())
        getData: (url) -> dispatch(actions.getData(url))
        saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))

export default MaterialPageConnected = connect(
    mapStateToProps,
    mapDispatchToProps
)(MaterialPage)
