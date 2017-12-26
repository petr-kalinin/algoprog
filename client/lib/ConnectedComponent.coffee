React = require('react')
FontAwesome = require('react-fontawesome')
deepEqual = require('deep-equal')
import { connect } from 'react-redux'
import { CometSpinLoader } from 'react-css-loaders';

import * as actions from '../redux/actions'
import * as getters from '../redux/getters'

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
                    return <CometSpinLoader/>
            else
                componentProps = {@props...}
                componentProps.handleReload = @handleReload
                delete componentProps.data
                delete componentProps.hasData
                delete componentProps.updateData
                delete componentProps.saveDataPromises
                delete componentProps.dispatch
                for key, url of @urls()
                    componentProps[key] = @props.data(url)
                return `<Component  {...componentProps}/>`

        componentWillMount: ->
            if not window?
                promises = @requestData(0)
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

        requestData: (timeout) ->
            promises = (@props.updateData(url, timeout) for key, url of @urls())
            return promises

        invalidateData: () ->
            (@props.invalidateData(url) for key, url of @urls())

        handleReload: (force) ->
            if force
                @invalidateData()
            @requestData(0)

        requestDataAndSetTimeout: () ->
            try
                await Promise.all(@requestData(options.timeout))
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

    mapDispatchToProps = (dispatch, ownProps) ->
        return
            invalidateData: (url) -> dispatch(actions.invalidateData(url))
            updateData: (url, timeout) -> dispatch(actions.updateData(url, timeout))
            saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))
            dispatch: dispatch

    return connect(mapStateToProps, mapDispatchToProps)(Result)
