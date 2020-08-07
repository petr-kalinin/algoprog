React = require('react')
moment = require('moment');
Entities = require('html-entities').XmlEntities;
entities = new Entities();
FontAwesome = require('react-fontawesome')
deepEqual = require('deep-equal')
JsDiff = require('diff')

import {parseDiff, markWordEdits, Diff} from 'react-diff-view';
import {Link} from 'react-router-dom'

import Grid from 'react-bootstrap/lib/Grid'
import Col from 'react-bootstrap/lib/Col'
import Button from 'react-bootstrap/lib/Button'
import Panel from 'react-bootstrap/lib/Panel'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'

import Submit, {SubmitHeader} from './Submit'
import FieldGroup from './FieldGroup'
import SubmitListTable from './SubmitListTable'
import BestSubmits from './BestSubmits'

import callApi from '../lib/callApi'

import isPaid, { isMuchUnpaid } from '../lib/isPaid'

import ConnectedComponent from '../lib/ConnectedComponent'

import styles from './ReviewResult.css'

TAIL_TEXTS = ["Решение проигнорировано", "Решение зачтено"]

class ProblemCommentsLists extends React.Component
    render: () ->
        <div>
            <h4>Предыдущие комментарии по этой задаче:</h4>
            {@props.data.map((comment) =>
                <pre key={comment._id} onClick={@props.handleCommentClicked(comment)} dangerouslySetInnerHTML={{__html: comment.text}}/>
            )}
        </div>

listOptions =
    urls: (props) ->
        data: "lastCommentsByProblem/#{props.problemId}"

ConnectedProblemCommentsLists = ConnectedComponent(ProblemCommentsLists, listOptions)


export class ReviewResult extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            commentText: ""
            currentSubmit: if @props.submits then @props.submits[@props.submits.length - 1] else null
            currentDiff: [undefined, undefined]
            bestSubmits: false
        @accept = @accept.bind this
        @ignore = @ignore.bind this
        @disqualify = @disqualify.bind this
        @comment = @comment.bind this
        @setField = @setField.bind this
        @setComment = @setComment.bind this
        @setCurrentSubmit = @setCurrentSubmit.bind this
        @setCurrentDiff = @setCurrentDiff.bind this
        @setQuality = @setQuality.bind this
        @toggleBestSubmits = @toggleBestSubmits.bind this
        @downloadSubmits = @downloadSubmits.bind this
        @copyTest = @copyTest.bind this

    copyTest: (result) ->
        (e) =>
            e.stopPropagation()
            newComment = @state.commentText
            if newComment.length
                newComment += "\n\n"
            newComment += "Входные данные:\n#{result.input.trim()}\n\nВывод программы:\n#{result.output.trim()}\n\nПравильный ответ:\n#{result.corr.trim()}"
            @setState
                commentText: newComment 
            return false

    setResult: (result) ->
        @syncSetOutcome(result)
        @props.handleDone?()

    syncSetOutcome: (result) ->
        await callApi "setOutcome/#{@state.currentSubmit._id}", {
            result,
            comment: @state.commentText
        }
        @props.syncHandleDone?()
        @props.handleReload()

    componentDidUpdate: (prevProps, prevState) ->
        if prevProps.result._id != @props.result._id
            @setState
                commentText: ""
                currentSubmit: if @props.submits then @props.submits[@props.submits.length - 1] else null
                bestSubmits: @state.bestSubmits
                currentDiff: @state.currentDiff
        else
            newState =
                commentText: @state.commentText
                currentSubmit: null
                bestSubmits: @state.bestSubmits
                currentDiff: @state.currentDiff
            for submit in @props.submits
                if submit._id == @state.currentSubmit?._id
                    newState.currentSubmit = submit
            if not deepEqual(newState, @state)
                @setState(newState)

    downloadSubmits: () ->
        await callApi "downloadSubmitsForUserAndProblem/#{@props.user._id}/#{@props.result.fullTable._id}"
        @props.handleReload()

    accept: () ->
        @setResult("AC")

    ignore: () ->
        @setResult("IG")

    disqualify: () ->
        @setResult("DQ")

    comment: () ->
        @setResult(null)


    setQuality: (quality) ->
        () =>
            await callApi "setQuality/#{@state.currentSubmit._id}/#{quality}", {}
            @props.handleReload()

    toggleBestSubmits: (e) ->
        if e
            e.preventDefault()
        @setState
            bestSubmits: not @state.bestSubmits

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
                currentDiff: [undefined, undefined]

    setCurrentDiff: (i, submit) ->
        (e) =>
            e.preventDefault()
            e.stopPropagation()
            newDiff = @state.currentDiff
            newDiff[i] = submit
            if not newDiff[1-i]
                newDiff[1-i] = @state.currentSubmit
            @setState
                currentSubmit: undefined
                currentDiff: newDiff

    paidStyle: () ->
        user = @props.user
        if (!user?.paidTill)
            styles.nonpaid
        else if isPaid(user)
            styles.paid
        else if !isMuchUnpaid(user)
            styles.unpaid
        else
            styles.muchUnpaid

    render:  () ->
        admin = @props.me?.admin
        <div className={@paidStyle()}>
            <Grid fluid>
                <Col xs={12} sm={12} md={8} lg={8}>
                    {
                    if @state.currentSubmit
                        <div>
                            <Submit submit={@state.currentSubmit} showHeader me={@props.me} copyTest={@copyTest}/>
                            {
                            admin and not @state.currentSubmit.similar and <div>
                                <div>
                                    {
                                    if @state.currentSubmit.outcome in ["OK", "AC"]
                                        starsClass = styles.stars
                                    else
                                        starsClass = ""
                                    <div className={starsClass}>
                                        <FontAwesome name="times" key={0} onClick={@setQuality(0)}/>
                                        {(<FontAwesome
                                            name={"star" + (if x <= @state.currentSubmit.quality then "" else "-o")}
                                            key={x}
                                            onClick={@setQuality(x)}/> \
                                            for x in [1..5])}
                                    </div>
                                    }
                                </div>
                                {
                                if @props.bestSubmits.length
                                    <span>
                                        <a href="#" onClick={@toggleBestSubmits}>Хорошие решения</a>
                                        {" = " + @props.bestSubmits.length}
                                        {" " + @props.bestSubmits.map((submit) -> submit.language || "unknown").join(", ")}
                                    </span>
                                }
                                <FieldGroup
                                        id="commentText"
                                        label="Комментарий"
                                        componentClass="textarea"
                                        setField={@setField}
                                        style={{ height: 200 }}
                                        state={@state}/>
                                    <FormGroup>
                                        {
                                        bsSize = null
                                        bsCommentSize = null
                                        if not (@state.currentSubmit.outcome in ["OK", "AC", "IG"])
                                            bsSize = "xsmall"
                                        if not @props.result?.activated
                                            bsSize = "xsmall"
                                            bsCommentSize = "xsmall"
                                        <ButtonGroup>
                                            <Button onClick={@accept} bsStyle="success" bsSize={bsSize}>Зачесть</Button>
                                            <Button onClick={@ignore} bsStyle="info" bsSize={bsSize}>Проигнорировать</Button>
                                            <Button onClick={@comment}  bsSize={bsCommentSize}>Прокомментировать</Button>
                                            <Button onClick={@disqualify} bsStyle="danger" bsSize="xsmall">Дисквалифицировать</Button>
                                        </ButtonGroup>
                                        }
                                    </FormGroup>
                                    <Button onClick={@downloadSubmits} bsSize="xsmall">re-download submits</Button>
                                </div>
                            }
                        </div>
                    else if @state.currentDiff[1] and @state.currentDiff[0]
                        if @state.currentDiff[1].source == @state.currentDiff[0].source
                            <div>
                                <SubmitHeader submit={@state.currentDiff[0]} admin={admin}/>
                                <pre>Нет изменений</pre>
                            </div>
                        else
                            diffText = JsDiff.createTwoFilesPatch(
                                @state.currentDiff[1]._id,
                                @state.currentDiff[0]._id,
                                @state.currentDiff[1].sourceRaw,
                                @state.currentDiff[0].sourceRaw)
                            diffText = diffText.split("\n")
                            diffText[0] = "diff --git a/#{@state.currentDiff[0]._id} b/#{@state.currentDiff[1]._id}\nindex aaaaaaa..aaaaaaa 100644"
                            diffText = diffText.join("\n")
                            files = parseDiff(diffText, {nearbySequences: "zip"})

                            <div>
                                <SubmitHeader submit={@state.currentDiff[0]} admin={admin}/>
                                <pre>
                                    {files.map(({hunks}, i) => <Diff key={i} hunks={hunks} viewType="split"/>)}
                                </pre>
                            </div>
                    }
                </Col>
                <Col xs={12} sm={12} md={4} lg={4}>
                    <SubmitListTable
                        submits={@props.submits}
                        handleSubmitClick={@setCurrentSubmit}
                        handleDiffClick={@setCurrentDiff}
                        activeId={@state.currentSubmit?._id}
                        activeDiffId={@state.currentDiff.map((submit)->submit?._id)}/>
                </Col>
                {
                admin and @state.currentSubmit and not @state.currentSubmit.similar and <Col xs={12} sm={12} md={12} lg={12}>
                    <ConnectedProblemCommentsLists problemId={@props.result.fullTable._id} handleCommentClicked={@setComment}/>
                </Col>
                }
                {
                admin && @state.bestSubmits && <BestSubmits submits={@props.bestSubmits} close={@toggleBestSubmits} stars/>
                }
            </Grid>
        </div>

SubmitsAndSimilarMerger = (props) ->
    for submit in props.submits
        submit.similar = false
    newSubmits = props.submits
    if props.similar and Array.isArray(props.similar)
        for submit in props.similar
            submit.similar = true
        newSubmits = props.similar.reverse().concat(props.submits)
    `<ReviewResult  {...props} submits={newSubmits}/>`

options =
    urls: (props) ->
        submits: "submits/#{props.result.fullUser._id}/#{props.result.fullTable._id}"
        user: "user/#{props.result.fullUser._id}"
        bestSubmits: "bestSubmits/#{props.result.fullTable._id}"
        me: "me"
    timeout: 0

optionsForSimilar = 
    urls: (props) ->
        if props.submits and props.me?.admin
            similar: "similarSubmits/#{props.submits[props.submits.length - 1]?._id}"
        else
            {}
    propogateReload: true

export default ConnectedComponent(ConnectedComponent(SubmitsAndSimilarMerger, optionsForSimilar), options)
