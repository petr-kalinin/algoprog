React = require('react')
moment = require('moment')

import Panel from 'react-bootstrap/lib/Panel'
import PanelGroup from 'react-bootstrap/lib/PanelGroup'

import {bootstrapUtils} from 'react-bootstrap/lib/utils'
import {Link} from 'react-router-dom'
import { connect } from 'react-redux'

import Notifications from 'react-notification-system-redux';

import {notify} from '../lib/BrowserNotifications'
import ConnectedComponent from '../lib/ConnectedComponent'

import callApi from '../lib/callApi'

import globalStyles from './global.css'

bootstrapUtils.addStyle(Panel, 'dq_text');
bootstrapUtils.addStyle(Panel, 'success');
bootstrapUtils.addStyle(Panel, 'info');

commentClass = (comment) ->
    switch comment.outcome
        when "AC" then "success"
        when "IG" then "info"
        else undefined

commentPanelClass = (comment) ->
    if comment.outcome == "DQ"
        return "dq_text"
    return commentClass(comment)

commentText = (comment) ->
    switch comment.outcome
        when "AC" then "Решение зачтено"
        when "IG" then "Решение проигнорировано"
        when "DQ" then "Решение дисквалифицировано"
        else "Решение прокомментировано"

commentAdd = (comment) ->
    MAX_LENGTH = 50
    if comment.text.length > MAX_LENGTH
        comment.text.substr(0, MAX_LENGTH) + "..."
    else 
        comment.text

class CommentList extends React.Component
    constructor: (props) ->
        super(props)
        @markAsViewed = @markAsViewed.bind this
        @state =
            viewed: {}

    markAsViewed: (commentId) ->
        (e) =>
            e.preventDefault()
            await callApi "setCommentViewed/#{commentId}", {}
            await @props.handleReload()

    componentDidUpdate: (prevProps) ->
        # do not show anything if we do not have comments or we were not logged in
        if (not @props.data?.length) || (not prevProps.data?.length)
            return
        viewedComments = {}
        for comment in prevProps.data || []
            viewedComments[comment._id] = 1
        for comment in @props.data
            if comment._id of viewedComments
                continue
            cl = commentClass(comment) || "error"
            url = "/material/#{comment.problemId}"
            message = commentText(comment)
            add = commentAdd(comment)
            title = comment.problemName
            notification =
                title: title
                message: message
                position: 'br',
                autoDismiss: 0,
                children: [
                    <Link to={url}>Перейти к задаче</Link>
                ]
            @props.showNotification(notification, cl)
            notify(comment._id, title, message + "\n" + add, url)

    render:  () ->
        if not @props.myUser?._id
            return null
        <div>
            <h4>Последние комментарии</h4>
            <PanelGroup id="comments">
                {
                if @props.data?.length
                    @props.data.map((comment) =>
                        cl = commentPanelClass(comment)
                        title =
                            <span>
                                {comment.problemName}
                                <button type="button" className="close" onClick={@markAsViewed(comment._id)}>
                                    <span>&times;</span>
                                </button>
                            </span>
                        <Panel key={comment._id} bsStyle={cl}>
                            <Panel.Heading>
                                <Panel.Title toggle>{title}</Panel.Title>
                            </Panel.Heading>
                            <Panel.Collapse>
                                <Panel.Body>
                                    <pre dangerouslySetInnerHTML={{__html: comment.text}}></pre>
                                    <Link to="/material/#{comment.problemId}">Перейти к задаче</Link>
                                </Panel.Body>
                            </Panel.Collapse>
                        </Panel>
                    )
                }
            </PanelGroup>
            <Link to="/comments">Все комментарии</Link>
        </div>

mapStateToProps = () -> {}
mapDispatchToProps = (dispatch) ->
    showNotification: (notification, cl) -> dispatch(Notifications.show(notification, cl))

CommentListWithNotifications = connect(mapStateToProps, mapDispatchToProps)(CommentList)


options = {
    urls: (props) ->
        return
            myUser: "myUser"
            data: "lastComments"

    timeout: 20000
}

export default ConnectedComponent(CommentListWithNotifications, options)
