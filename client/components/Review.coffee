React = require('react')
moment = require('moment');
Entities = require('html-entities').XmlEntities;
entities = new Entities();

import {Link} from 'react-router-dom'

import Button from 'react-bootstrap/lib/Button'
import Panel from 'react-bootstrap/lib/Panel'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'

import Submit from './Submit'
import FieldGroup from './FieldGroup'

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
        @accept = @accept.bind this
        @ignore = @ignore.bind this
        @comment = @comment.bind this
        @setField = @setField.bind this
        @setComment = @setComment.bind this

    @url: (props) ->
        'submit/' + props.result.lastSubmitId

    setResult: (result) ->
        callApi "setOutcome/#{@props.result.lastSubmitId}", {
            result,
            comment: @state.commentText
        }
        @props.handleDone()

    componentDidUpdate: (prevProps, prevState) ->
        if prevProps.result._id != @props.result._id
            @setState
                commentText: ""

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

    render:  () ->
        <div>
            <Submit submit={@props.data} showHeader/>
            <FieldGroup
                id="commentText"
                label="Комментарий"
                componentClass="textarea"
                setField={@setField}
                style={{ height: 200 }}
                state={@state}/>
            <FormGroup>
                {
                if @props.data.fullUser.userList != "unknown"
                    <ButtonGroup>
                        <Button onClick={@accept} bsStyle="success">Зачесть</Button>
                        <Button onClick={@ignore} bsStyle="info">Проигнорировать</Button>
                        <Button onClick={@comment}>Прокомментировать</Button>
                    </ButtonGroup>
                else
                    <Button onClick={@props.handleDone}>Пропустить</Button>
                }
            </FormGroup>
            <ConnectedProblemCommentsLists problemId={@props.data.problem} handleCommentClicked={@setComment}/>
        </div>

ConnectedReviewResult = ConnectedComponent(ReviewResult)


export default class Review extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            results: (r for r in props.data.ok when r.userList != "unknown")
        @gotoNext = @gotoNext.bind this

    gotoNext: () ->
        @setState
            results: @state.results[...-1]

    render: () ->
        if @state.results.length == 0
            return <div>Ревьювить больше нечего, обновите страницу</div>
        <div>
            <ConnectedReviewResult result={@state.results[@state.results.length-1]} handleDone={@gotoNext}/>
            {@state.results.length > 1 &&    # prefetch next submit
                <div style={{display: "none"}}>
                    <ConnectedReviewResult result={@state.results[@state.results.length-2]} handleDone={@gotoNext}/>
                </div>}
        </div>
