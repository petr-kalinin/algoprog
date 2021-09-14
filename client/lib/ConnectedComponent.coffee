React = require('react')
FontAwesome = require('react-fontawesome')
deepEqual = require('deep-equal')
import { connect } from 'react-redux'

import Loader from '../components/Loader'

import * as actions from '../redux/actions'
import * as getters from '../redux/getters'

import awaitAll from '../lib/awaitAll'

import {subscribeWsSet, unsubscribeWsSet} from './WebsocketsSet'

class ErrorBoundary extends React.Component 
    constructor: (props) ->
        super(props)
        this.state = { error: null, errorInfo: null }

    componentDidCatch: (error, errorInfo) ->
        this.setState
            error: error,
            errorInfo: errorInfo

    render: () ->
        if this.state.errorInfo 
            return <h1><FontAwesome name="exclamation-circle"/></h1>     
        return this.props.children;

export default ConnectedComponent = (Component, options) ->
    class Result extends React.Component
        constructor: (props) ->
            super(props)
            @handleReload = @handleReload.bind(this)
            if window?
                @requestWsData()
            else if @props.needDataPromises
                promises = @requestData(1000)  # allow pre-fill of state
                @props.saveDataPromises(promises)

        urls: () ->
            options.urls(@props)

        wsurls: () ->
            options.wsurls?(@props)

        dataLoaded: () ->
            for key, url of {@urls()..., @wsurls()...}
                if not @props.hasData(url)
                    return false
            return true

        dataRejected: () ->
            for key, url of {@urls()..., @wsurls()...}
                if @props.isDataRejected(url)
                    return true
            return false

        render:  () ->
            if @dataRejected()
                <h1><FontAwesome name="exclamation-circle"/></h1>
            else if not @dataLoaded() and not options.allowNotLoaded
                if options.Placeholder
                    Placeholder = options.Placeholder
                    return <Placeholder/>
                else
                    return <Loader/>
            else
                componentProps = {@props...}
                componentProps.handleReload = @handleReload
                delete componentProps.data
                delete componentProps.hasData
                delete componentProps.updateData
                delete componentProps.updateWsData
                delete componentProps.saveDataPromises
                delete componentProps.clientCookie
                for key, url of {@urls()..., @wsurls()...}
                    componentProps[key] = @props.data(url)
                return `<ErrorBoundary><Component  {...componentProps}/></ErrorBoundary>`

        componentDidMount: ->
            @requestDataAndSetTimeout()

        componentWillUnmount: ->
            for key, url of @wsurls()
                unsubscribeWsSet(url)
            if @timeout
                clearTimeout(@timeout)

        componentDidUpdate: (prevProps, prevState) ->
            if window?
                if not deepEqual(options.wsurls?(prevProps), options.wsurls?(@props))
                    for key, url of options.wsurls?(prevProps)
                        unsubscribeWsSet(url)
                    @requestWsData()
            if not deepEqual(options.urls(prevProps), options.urls(@props))
                @requestData(options.timeout)
            else
                # this will request data only if it was not requested yet
                @requestData()

        requestWsData: () ->
            for key, url of @wsurls()
                subscribeWsSet(url)
            (@props.updateWsData(url) for key, url of @wsurls())

        requestData: (timeout) ->
            promises = (@props.updateData(url, timeout, @props.clientCookie) for key, url of @urls())
            return promises

        invalidateData: () ->
            (@props.invalidateData(url) for key, url of @urls())

        handleReload: (force) ->
            if force
                @invalidateData()
            @requestData(0)
            if options.propogateReload
                @props.handleReload?()

        requestDataAndSetTimeout: () ->
            try
                await awaitAll(@requestData(options.timeout))
            catch e
                console.log "Can't reload data", @urls(), e
            if options.timeout
                @timeout = setTimeout((() => @requestDataAndSetTimeout()), options.timeout)

    mapStateToProps = (state, ownProps) ->
        data: (url) -> getters.getData(state, url)
        hasData: (url) -> getters.hasData(state, url)
        isDataRejected: (url) -> getters.isDataRejected(state, url)
        clientCookie: state.clientCookie
        needDataPromises: state.needDataPromises

    mapDispatchToProps = (dispatch, ownProps) ->
        invalidateData: (url) -> dispatch(actions.invalidateData(url))
        updateData: (url, timeout, cookies) -> dispatch(actions.updateData(url, timeout, cookies))
        saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))
        updateWsData: (url) -> dispatch(actions.updateWsData(url))

    return connect(mapStateToProps, mapDispatchToProps)(Result)
