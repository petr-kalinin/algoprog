React = require('react')
moment = require('moment');
import {Link} from 'react-router-dom'

import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'

import Submit from './Submit'
import FieldGroup from './FieldGroup'

import callApi from '../lib/callApi'

import ConnectedComponent from '../pages/ConnectedComponent'

class ReviewResult extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            commentText: ""
        @accept = @accept.bind this
        @ignore = @ignore.bind this
        @comment = @comment.bind this
        @setField = @setField.bind this

    @url: (props) ->
        'submit/' + props.result.lastSubmitId

    setResult: (result) ->
        callApi "/setOutcome/#{@props.result.lastSubmitId}", {
            result,
            comment: @state.commentText
        }

    accept: () ->
        @setResult("AC")

    ignore: () ->
        @setResult("IG")

    comment: () ->
        @setResult(null)

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
            <ButtonGroup>
                <Button onClick={@accept} bsStyle="success">Зачесть</Button>
                <Button onClick={@ignore} bsStyle="info">Проигнорировать</Button>
                <Button onClick={@comment}>Прокомментировать</Button>
            </ButtonGroup>
        </div>

ConnectedReviewResult = ConnectedComponent(ReviewResult)


export default class Review extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            results: props.data.ok

    render: () ->
        if @state.results.length == 0
            return <div>Ревьювить больше нечего, обновите страницу</div>
        <div>
            <ConnectedReviewResult result={@state.results[@state.results.length-1]}/>
        </div>
