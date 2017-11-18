React = require('react')
moment = require('moment')

import Panel from 'react-bootstrap/lib/Panel'
import {Link} from 'react-router-dom'

import Notifications from 'react-notification-system-redux';

import ConnectedComponent from '../pages/ConnectedComponent'

import callApi from '../lib/callApi'

commentClass = (comment) ->
    switch comment.outcome
        when "AC" then "success"
        when "IG" then "info"
        else undefined

commentText = (comment) ->
    switch comment.outcome
        when "AC" then "Решение зачтено"
        when "IG" then "Решение проигнорировано"
        else "Решение прокомментировано"

class CommentList extends React.Component
    constructor: (props) ->
        super(props)
        @markAsViewed = @markAsViewed.bind this
        @state =
            viewed: {}

    @url: (props) ->
        if props?.myUser?._id
            "lastComments/#{props.myUser._id}"

    @timeout: () ->
        20 * 1000

    markAsViewed: (commentId) ->
        (e) =>
            e.preventDefault()
            await callApi "setCommentViewed/#{commentId}", {}
            await @props.handleReload()

    componentDidUpdate: (prevProps) ->
        # do not show anything if we do not have comments or we were not logged in
        if (not @props.data) || (not prevProps.myUser?._id)
            return
        viewedComments = {}
        for comment in prevProps.data || []
            viewedComments[comment._id] = 1
        for comment in @props.data
            if comment._id of viewedComments
                continue
            cl = commentClass(comment) || "error"
            notification =
                title: comment.problemName,
                message: commentText(comment),
                position: 'br',
                autoDismiss: 0,
                children:
                    <Link to="/material/#{comment.problemId}">Перейти к задаче</Link>
            @props.dispatch(Notifications.show(notification, cl));

    render:  () ->
        if not @props.myUser?._id
            return null
        <div>
            <h4>Последние комментарии</h4>
            {
            if @props.data?.length
                @props.data.map((comment) =>
                    cl = commentClass(comment)
                    title =
                        <span>
                            {comment.problemName}
                            <button type="button" className="close" onClick={@markAsViewed(comment._id)}>
                                <span>&times;</span>
                            </button>
                        </span>
                    <Panel collapsible key={comment._id} header={title} bsStyle={cl}>
                        <pre dangerouslySetInnerHTML={{__html: comment.text}}></pre>
                        <Link to="/material/#{comment.problemId}">Перейти к задаче</Link>
                    </Panel>
                )
            }
        </div>

export default ConnectedComponent(CommentList)
