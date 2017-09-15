React = require('react')
import { connect } from 'react-redux'
import { CometSpinLoader } from 'react-css-loaders';

import * as actions from '../redux/actions'

export default ConnectedComponent = (Component) ->
    class Result extends React.Component
        constructor: (props) ->
            super(props)
            @handleReload = @handleReload.bind(this)
            @handleLogout = @handleLogout.bind(this)

        url: ->
            if Component.url
                return Component.url(@props.match.params)

        dataOutdated: () ->
            if not @props.tree
                return true
            if not @props.news
                return true
            url = @url()
            if not url
                return false
            if not @props.data
                return true
            if @props.dataUrl == url
                return false
            if decodeURIComponent(@props.dataUrl) == url
                return false
            return true

        render:  () ->
            if @dataOutdated()
                if Component.Placeholder
                    return <Component.Placeholder/>
                else
                    return
                        <CometSpinLoader />
            else
                return `<Component  {...this.props} handleReload={this.handleReload}/>`

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
            if @url() and (Component.url(prevProps.match.params) != Component.url(@props.match.params))
                @requestData()

        requestData: () ->
            promises = [@props.getMe(), @props.getTree(), @props.getNews(), @props.getMyUser()]
            if @url()
                promises.push(@props.getData(@url()))
            return promises

        handleReload: () ->
            @requestData()

        handleLogout: () ->

        requestDataAndSetTimeout: () ->
            try
                await Promise.all(@requestData())
                console.log "Updated data"
            catch
                console.log "Can't reload data"
            if Component.timeout?()
                console.log "Setting timeout"
                @timeout = setTimeout((() => @requestDataAndSetTimeout()), Component.timeout())



    mapStateToProps = (state, ownProps) ->
        return
            me: state.me
            myUser: state.myUser
            tree: state.tree
            news: state.news
            dataUrl: state.data.url
            data: state.data.data

    mapDispatchToProps = (dispatch, ownProps) ->
        return
            getMe: () -> dispatch(actions.getMe())
            getMyUser: () -> dispatch(actions.getMyUser())
            getTree: () -> dispatch(actions.getTree())
            getNews: () -> dispatch(actions.getNews())
            getData: (url) -> dispatch(actions.getData(url))
            saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))
            logout: () -> dispatch(actions.logout(dispatch))
            reloadMyData: () -> dispatch(actions.getMe()); dispatch(actions.getMyUser()) 

    return connect(mapStateToProps, mapDispatchToProps)(Result)
