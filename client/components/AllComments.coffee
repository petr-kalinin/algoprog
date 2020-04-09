React = require('react')
moment = require('moment')

import Panel from 'react-bootstrap/lib/Panel'
import PanelGroup from 'react-bootstrap/lib/PanelGroup'
import {bootstrapUtils} from 'react-bootstrap/lib/utils'

FontAwesome = require('react-fontawesome')

import Pagination from "react-js-pagination";

import {Link} from 'react-router-dom'
import { connect } from 'react-redux'

import ConnectedComponent from '../lib/ConnectedComponent'

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

AllCommentList = (props) ->
    <PanelGroup id="comments">
        {
        if props.comments?.length
            props.comments.map((comment) =>
                cl = commentPanelClass(comment)
                title =
                    <Link to="/material/#{comment.problemId}">
                        {moment(comment.time).format('DD.MM.YY HH:mm:ss') + ": " + comment.problemName + " "}
                        <FontAwesome name="angle-double-right"/>
                    </Link>
                <Panel key={comment._id} bsStyle={cl}>
                    <Panel.Heading>
                        <Panel.Title>{title}</Panel.Title>
                    </Panel.Heading>
                    <Panel.Body>
                        <pre dangerouslySetInnerHTML={{__html: comment.text}}></pre>
                    </Panel.Body>
                </Panel>
            )
        }
    </PanelGroup>

options = {
    urls: (props) ->
        return
            comments: "comments/#{props.page}"
    timeout: 20000
}

AllCommentListConnected = ConnectedComponent(AllCommentList, options)

class AllCommentsWithPaginator extends React.Component
    constructor: (props) ->
        super(props);
        @state =
            activePage: 1
        @handlePageChange = @handlePageChange.bind this
    
    handlePageChange: (pageNumber) ->
        window.scrollTo(0, 0)
        @setState
            activePage: pageNumber
    
    render: () ->
        <div>
            <h1>Все комментарии</h1>
            <AllCommentListConnected page={@state.activePage - 1} />
            <Pagination
                activePage={@state.activePage}
                itemsCountPerPage={@props.data.commentsPerPage}
                totalItemsCount={@props.data.pagesCount * @props.data.commentsPerPage}
                pageRangeDisplayed={5}
                onChange={@handlePageChange}
            />
        </div>

pageOptions = {
    urls: (props) ->
        return
            data: "commentPages"
    timeout: 20000
}

export default ConnectedComponent(AllCommentsWithPaginator, pageOptions)
