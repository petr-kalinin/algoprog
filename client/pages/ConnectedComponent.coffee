React = require('react')
import { connect } from 'react-redux'
import { CometSpinLoader } from 'react-css-loaders';

import * as actions from '../redux/actions'

export default ConnectedComponent = (Component) ->
    class Result extends React.Component
        constructor: (props) ->
            super(props)

        url: ->
            return Component.url(@props.match.params)

        render:  () ->
            if @props.dataUrl != @url() or not @props.data
                return
                    <CometSpinLoader />
            else
                return`<Component  {...this.props}/>`

        componentWillMount: ->
            if not window?
                promises = @requestData()
                @props.saveDataPromises(promises)

        componentDidMount: ->
            @requestDataAndSetTimeout()

        componentWillUnmount: ->
            if @timeout
                clearTimeout(@timeout)

        componentDidUpdate: (prevProps, prevState) ->
            if Component.url(prevProps.match.params) != Component.url(@props.match.params)
                @requestData()

        requestData: () ->
            return [@props.getMe(), @props.getData(Component.url(@props.match.params)), @props.getTree(), @props.getNews()]

        requestDataAndSetTimeout: () ->
            try
                await Promise.all(@requestData())
            catch
                console.log "Can't reload dashboard"
            if Component.timeout?()
                console.log "Setting timeout"
                @timeout = setTimeout((() => @requestDataAndSetTimeout()), Component.timeout())



    mapStateToProps = (state, ownProps) ->
        return
            me: state.me
            tree: state.tree
            news: state.news
            dataUrl: state.data.url
            data: state.data.data

    mapDispatchToProps = (dispatch, ownProps) ->
        return
            getMe: () -> dispatch(actions.getMe())
            getTree: () -> dispatch(actions.getTree())
            getNews: () -> dispatch(actions.getNews())
            getData: (url) -> dispatch(actions.getData(url))
            saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))

    return connect(mapStateToProps, mapDispatchToProps)(Result)
