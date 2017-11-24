React = require('react')
moment = require('moment');
Entities = require('html-entities').XmlEntities;
entities = new Entities();

import {Link} from 'react-router-dom'

import Grid from 'react-bootstrap/lib/Grid'
import Col from 'react-bootstrap/lib/Col'
import Button from 'react-bootstrap/lib/Button'
import Panel from 'react-bootstrap/lib/Panel'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'

import Submit from './Submit'
import FieldGroup from './FieldGroup'
import SubmitListTable from './SubmitListTable'

import callApi from '../lib/callApi'

import ConnectedComponent from '../pages/ConnectedComponent'

TAIL_TEXTS = ["Решение проигнорировано", "Решение зачтено"]

class ProblemCommentsLists extends React.Component
    @url: (props) ->
        "lastCommentsByProblem/#{props.problemId}"

    render: () ->
        <div>
            <h4>Предыдущие комментарии по этой задаче:</h4>
            {@props.data.map((comment) =>
                <pre key={comment._id} onClick={@props.handleCommentClicked(comment)} dangerouslySetInnerHTML={{__html: comment.text}}/>
            )}
        </div>

ConnectedProblemCommentsLists = ConnectedComponent(ProblemCommentsLists)


class ReviewResult extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            commentText: ""
            currentSubmit: if @props.data then @props.data[@props.data.length - 1] else null
        @accept = @accept.bind this
        @ignore = @ignore.bind this
        @comment = @comment.bind this
        @setField = @setField.bind this
        @setComment = @setComment.bind this
        @setCurrentSubmit = @setCurrentSubmit.bind this

    @url: (props) ->
        "submits/#{props.result.fullUser._id}/#{props.result.fullTable._id}"

    setResult: (result) ->
        callApi "setOutcome/#{@state.currentSubmit._id}", {
            result,
            comment: @state.commentText
        }
        @props.handleDone()

    componentDidUpdate: (prevProps, prevState) ->
        if prevProps.result._id != @props.result._id
            @setState
                commentText: ""
                currentSubmit: if @props.data then @props.data[@props.data.length - 1] else null

    accept: () ->
        @setResult("AC")

    ignore: () ->
        @setResult("IG")

    comment: () ->
        @setResult(null)

    setComment: (comment) ->
        () =>
            newText = entities.decode(comment.text)
            newText = newText.trim()
            for tail in TAIL_TEXTS
                if newText.endsWith(tail)
                    newText = newText.substring(0, newText.length - tail.length);
            newText = newText.trim()
            if @state.commentText.length
                newText = @state.commentText + "\n\n" + newText
            @setField("commentText", newText)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    setCurrentSubmit: (submit) ->
        (e) =>
            e.preventDefault()
            @setState
                currentSubmit: submit

    render:  () ->
        admin = @props.me?.admin
        <Grid fluid>
            <Col xs={12} sm={12} md={8} lg={8}>
                {
                if @state.currentSubmit
                    <div>
                        <Submit submit={@state.currentSubmit} showHeader me={@props.me}/>
                        {
                        admin && <div>
                            <FieldGroup
                                    id="commentText"
                                    label="Комментарий"
                                    componentClass="textarea"
                                    setField={@setField}
                                    style={{ height: 200 }}
                                    state={@state}/>
                                <FormGroup>
                                    {
                                    if @props.result.userList != "unknown"
                                        bsSize = null
                                        if not (@state.currentSubmit.outcome in ["OK", "AC", "IG"])
                                            bsSize = "xsmall"
                                        <ButtonGroup>
                                            <Button onClick={@accept} bsStyle="success" bsSize={bsSize}>Зачесть</Button>
                                            <Button onClick={@ignore} bsStyle="info" bsSize={bsSize}>Проигнорировать</Button>
                                            <Button onClick={@comment}>Прокомментировать</Button>
                                        </ButtonGroup>
                                    else
                                        <Button onClick={@props.handleDone}>Пропустить</Button>
                                    }
                                </FormGroup>
                            </div>
                        }
                    </div>
                }
            </Col>
            <Col xs={12} sm={12} md={4} lg={4}>
                <SubmitListTable submits={@props.data} handleSubmitClick={@setCurrentSubmit} activeId={@state.currentSubmit?._id}/>
            </Col>
            {
            admin && <Col xs={12} sm={12} md={12} lg={12}>
                <ConnectedProblemCommentsLists problemId={@props.result.fullTable._id} handleCommentClicked={@setComment}/>
            </Col>
            }
        </Grid>

export default ConnectedComponent(ReviewResult)
