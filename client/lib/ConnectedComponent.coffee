React = require('react')
FontAwesome = require('react-fontawesome')
deepEqual = require('deep-equal')
import { connect } from 'react-redux'

import Loader from '../components/Loader'

import * as actions from '../redux/actions'
import * as getters from '../redux/getters'

import awaitAll from '../lib/awaitAll'

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

        urls: () ->
            options.urls(@props)

        dataLoaded: () ->
            for key, url of @urls()
                if not @props.hasData(url)
                    return false
            return true

        dataRejected: () ->
            for key, url of @urls()
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
                delete componentProps.saveDataPromises
                delete componentProps.clientCookies
                for key, url of @urls()
                    componentProps[key] = @props.data(url)
                return `<ErrorBoundary><Component  {...componentProps}/></ErrorBoundary>`

        componentWillMount: ->
            if not window?
                promises = @requestData(1000)  # allow pre-fill of state
                @props.saveDataPromises(promises)

        componentDidMount: ->
            @requestDataAndSetTimeout()

        componentWillUnmount: ->
            if @timeout
                console.log "Clearing timeout"
                clearTimeout(@timeout)

        componentDidUpdate: (prevProps, prevState) ->
            if not deepEqual(options.urls(prevProps), options.urls(@props))
                @requestData(options.timeout)
            else
                # this will request data only if it was not requested yet
                @requestData()

        requestData: (timeout) ->
            promises = (@props.updateData(url, timeout, @props.clientCookie) for key, url of @urls())
            return promises

        invalidateData: () ->
            (@props.invalidateData(url) for key, url of @urls())

        handleReload: (force) ->
            if force
                @invalidateData()
            @requestData(0)

        requestDataAndSetTimeout: () ->
            try
                await awaitAll(@requestData(options.timeout))
                console.log "Updated data", @urls()
            catch e
                console.log "Can't reload data", @urls(), e
            if options.timeout
                console.log "Setting timeout", @urls()
                @timeout = setTimeout((() => @requestDataAndSetTimeout()), options.timeout)

    mapStateToProps = (state, ownProps) ->
        return
            data: (url) -> getters.getData(state, url)
            hasData: (url) -> getters.hasData(state, url)
            isDataRejected: (url) -> getters.isDataRejected(state, url)
            clientCookie: state.clientCookie

    mapDispatchToProps = (dispatch, ownProps) ->
        return
            invalidateData: (url) -> dispatch(actions.invalidateData(url))
            updateData: (url, timeout, cookies) -> dispatch(actions.updateData(url, timeout, cookies))
            saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))

    return connect(mapStateToProps, mapDispatchToProps)(Result)
