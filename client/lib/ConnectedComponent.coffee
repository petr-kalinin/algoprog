React = require('react')
deepEqual = require('deep-equal')
import { connect } from 'react-redux'
import { CometSpinLoader } from 'react-css-loaders';

import * as actions from '../redux/actions'
import * as getters from '../redux/getters'

export default ConnectedComponent = (Component) ->
    class Result extends React.Component
        constructor: (props) ->
            super(props)
            @handleReload = @handleReload.bind(this)

        urls: () ->
            Component.urls(@props)

        dataLoaded: () ->
            for key, url of @urls()
                if not @props.data(url)
                    return false
            return true

        render:  () ->
            if not @dataLoaded()
                if Component.Placeholder
                    return <Component.Placeholder/>
                else
                    return <CometSpinLoader/>
            else
                componentProps = {@props...}
                componentProps.handleReload = @handleReload
                for key, url of @urls()
                    componentProps[key] = @props.data(url)
                return `<Component  {...componentProps}/>`

        componentWillMount: ->
            if not window?
                promises = @requestData()
                @props.saveDataPromises(promises)

        componentDidMount: ->
            @requestDataAndSetTimeout()

        componentWillUnmount: ->
            if @timeout
                console.log "Clearing timeout"
                clearTimeout(@timeout)

        componentDidUpdate: (prevProps, prevState) ->
            if not deepEqual(Component.url(prevProps), Component.url(@props))
                @requestData()

        requestData: () ->
            promises = [@props.getData(url, true) for key, url in @urls()]
            return promises

        handleReload: () ->
            @requestData()

        requestDataAndSetTimeout: () ->
            try
                await Promise.all(@requestData())
                console.log "Updated data", @url()
            catch e
                console.log "Can't reload data", @url(), e
            if Component.timeout?()
                console.log "Setting timeout", @url()
                @timeout = setTimeout((() => @requestDataAndSetTimeout()), Component.timeout())



    mapStateToProps = (state, ownProps) ->
        return
            data: (url) -> getters.getData(state, url)

    mapDispatchToProps = (dispatch, ownProps) ->
        return
            getData: (url, force) -> dispatch(actions.getData(url, force))
            saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))
            reloadMyData: () -> dispatch(actions.postLogin())
            dispatch: dispatch

    return connect(mapStateToProps, mapDispatchToProps)(Result)
