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
            promises = @requestData()
            if not window?
                @props.saveDataPromises(promises)

        componentDidUpdate: (prevProps, prevState) ->
            if Component.url(prevProps.match.params) != Component.url(@props.match.params)
                @requestData()

        requestData: () ->
            return [@props.getMe(), @props.getData(Component.url(@props.match.params)), @props.getTree(), @props.getNews()]


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
