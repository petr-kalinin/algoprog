React = require('react')
import { connect } from 'react-redux'
import { CometSpinLoader } from 'react-css-loaders';

import * as actions from '../redux/actions'
import * as getters from '../redux/getters'

export default ConnectedComponent = (Component) ->
    class Result extends React.Component
        constructor: (props) ->
            super(props)
            @handleReload = @handleReload.bind(this)

        url: ->
            if Component.url
                return Component.url(@props)

        dataOutdated: () ->
            if not @props.tree
                return true
            if not @props.news
                return true
            url = @url()
            if not url
                return false
            return not @props.data(url)

        render:  () ->
            if @dataOutdated()
                if Component.Placeholder
                    return <Component.Placeholder/>
                else
                    return
                        <CometSpinLoader />
            else
                componentProps = {@props...}
                componentProps.handleReload = @handleReload
                componentProps.data = @props.data(@url())
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
            if @url() and (Component.url(prevProps) != Component.url(@props))
                @requestData()

        requestData: () ->
            promises = [@props.getMe(), @props.getTree(), @props.getNews(), @props.getMyUser()]
            if @url()
                promises.push(@props.getData(@url(), true))
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
            me: getters.getMe(state),
            myUser: getters.getMyUser(state),
            tree: getters.getTree(state),
            news: getters.getNews(state),
            data: (url) -> getters.getData(state, url)

    mapDispatchToProps = (dispatch, ownProps) ->
        return
            getMe: () -> dispatch(actions.getMe())
            getMyUser: () -> dispatch(actions.getMyUser())
            getTree: () -> dispatch(actions.getTree())
            getNews: () -> dispatch(actions.getNews())
            getData: (url, force) -> dispatch(actions.getData(url, force))
            saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))
            logout: () -> dispatch(actions.logout(dispatch))
            reloadMyData: () -> dispatch(actions.postLogin())
            dispatch: dispatch

    return connect(mapStateToProps, mapDispatchToProps)(Result)
