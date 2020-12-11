React = require('react')
moment = require('moment');
Entities = require('html-entities').XmlEntities;
entities = new Entities();
FontAwesome = require('react-fontawesome')
deepEqual = require('deep-equal')
deepcopy = require('deepcopy')

import {Link} from 'react-router-dom'

import Grid from 'react-bootstrap/lib/Grid'
import Col from 'react-bootstrap/lib/Col'
import Button from 'react-bootstrap/lib/Button'
import Panel from 'react-bootstrap/lib/Panel'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'

import BestSubmits from './BestSubmits'
import {DiffEditor} from './Editor'
import FieldGroup from './FieldGroup'
import Submit, {SubmitHeader} from './Submit'
import SubmitListTable from './SubmitListTable'

import callApi from '../lib/callApi'

import isPaid, { isMuchUnpaid } from '../lib/isPaid'

import ConnectedComponent from '../lib/ConnectedComponent'

import styles from './ReviewResult.css'

TAIL_TEXTS = ["Решение проигнорировано", "Решение зачтено"]

submitListEquals = (submits1, submits2) ->
    if submits1.length != submits2.length
        return false
    for s, i in submits1
        if s._id != submits2[i]._id
            return false
    return true

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

# TODO: get rid of this wrapper?
class SubmitForReviewResults extends React.Component
    render: () ->
        admin = @props.me?.admin
        <div>
            <Submit submit={@props.currentSubmit} showHeader me={@props.me} copyTest={@props.copyTest} headerSticky={true} headerClassName={@props.headerClassName}/>
        </div>

export class SubmitListWithDiff extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            currentSubmit: if @props.submits then @props.submits[@props.submits.length - 1] else null
            currentDiff: [undefined, undefined]
        @props.setCurrentSubmit?(@state.currentSubmit)
        @setCurrentSubmit = @setCurrentSubmit.bind this
        @setCurrentDiff = @setCurrentDiff.bind this

    componentDidUpdate: (prevProps, prevState) ->
        if !submitListEquals(prevProps.submits, @props.submits)
            @setState
                currentSubmit: if @props.submits then @props.submits[@props.submits.length - 1] else null
                currentDiff: [undefined, undefined]
            @props.setCurrentSubmit?(@state.currentSubmit)
        else
            newState =
                currentSubmit: null
                currentDiff: @state.currentDiff
            for submit in @props.submits
                if submit._id == @state.currentSubmit?._id
                    newState.currentSubmit = submit
            if not deepEqual(newState, @state)
                @setState(newState)
            @props.setCurrentSubmit?(@state.currentSubmit)

    setCurrentSubmit: (submit) ->
        (e) =>
            e.preventDefault()
            @setState
                currentSubmit: submit
                currentDiff: [undefined, undefined]
            @props.setCurrentSubmit?(submit)

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
            @props.setCurrentSubmit?(submit)

    render:  () ->
        SubmitComponent = @props.SubmitComponent
        allProps = {@props..., @state...}
        PostSubmit = @props.PostSubmit
        admin = @props.me?.admin
        <Grid fluid>
            <Col xs={12} sm={12} md={8} lg={8}>
                {
                if @state.currentSubmit
                    <div>
                        {`<SubmitComponent {...allProps}/>`}
                    </div>
                else if @state.currentDiff[1] and @state.currentDiff[0]
                    <>
                        <SubmitHeader submit={@state.currentDiff[0]} admin={admin}/>
                        <DiffEditor original={@state.currentDiff[1].sourceRaw} modified={@state.currentDiff[0].sourceRaw}/>
                    </>
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
            {PostSubmit && `<Col xs={12} sm={12} md={12} lg={12}><PostSubmit {...allProps}/></Col>`}
        </Grid>

SubmitActions = (props) ->
    admin = props.me?.admin
    <div>
        {props.currentSubmit && (not props.currentSubmit.similar) && (not props.result.findMistake) && <div>
            <div>
                {
                if props.currentSubmit.outcome in ["OK", "AC"]
                    starsClass = styles.stars
                else
                    starsClass = ""
                <div className={starsClass}>
                    <FontAwesome name="times" key={0} onClick={props.setQuality(0)}/>
                    {(<FontAwesome
                        name={"star" + (if x <= props.currentSubmit.quality then "" else "-o")}
                        key={x}
                        onClick={props.setQuality(x)}/> \
                        for x in [1..5])}
                </div>
                }
            </div>
            {
            if props.bestSubmits?.length
                <span>
                    <a href="#" onClick={props.toggleBestSubmits}>Хорошие решения</a>
                    {" = " + props.bestSubmits.length}
                    {" " + props.bestSubmits.map((submit) -> submit.language || "unknown").join(", ")}
                </span>
            }
            <FieldGroup
                    id="commentText"
                    label="Комментарий"
                    componentClass="textarea"
                    setField={props.setField}
                    style={{ height: 200 }}
                    state={props}/>
            <FormGroup>
                {
                bsSize = null
                bsCommentSize = null
                if not (props.currentSubmit.outcome in ["OK", "AC", "IG"])
                    bsSize = "xsmall"
                if not props.result?.activated
                    bsSize = "xsmall"
                    bsCommentSize = "xsmall"
                <ButtonGroup>
                    <Button onClick={props.accept} bsStyle="success" bsSize={bsSize}>Зачесть</Button>
                    <Button onClick={props.ignore} bsStyle="info" bsSize={bsSize}>Проигнорировать</Button>
                    <Button onClick={props.comment}  bsSize={bsCommentSize}>Прокомментировать</Button>
                    <Button onClick={props.disqualify} bsStyle="danger" bsSize="xsmall">Дисквалифицировать</Button>
                </ButtonGroup>
                }
            </FormGroup>
            <Button onClick={props.downloadSubmits} bsSize="xsmall">re-download submits</Button>
            {
            admin and props.currentSubmit and not props.currentSubmit.similar and <Col xs={12} sm={12} md={12} lg={12}>
                <ConnectedProblemCommentsLists problemId={props.result.fullTable._id} handleCommentClicked={props.setComment}/>
            </Col>
            }
            {
            admin && props.showBestSubmits && <BestSubmits submits={props.bestSubmits} close={props.toggleBestSubmits} stars/>
            }
        </div>}
        {props.result.findMistake && 
            <>
                <Button onClick={props.downloadSubmits} bsSize="xsmall">re-download submits</Button><br/>
                <Link to="/findMistake/#{props.result.findMistake}">Исходный поиск ошибки</Link>
            </>
        }
    </div>

export class ReviewResult extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            commentText: ""
            showBestSubmits: false
        @currentSubmit = null
        @accept = @accept.bind this
        @ignore = @ignore.bind this
        @disqualify = @disqualify.bind this
        @comment = @comment.bind this
        @setField = @setField.bind this
        @setQuality = @setQuality.bind this
        @toggleBestSubmits = @toggleBestSubmits.bind this
        @downloadSubmits = @downloadSubmits.bind this
        @setComment = @setComment.bind this
        @copyTest = @copyTest.bind this
        @setCurrentSubmit = @setCurrentSubmit.bind this

    componentDidUpdate: (prevProps, prevState) ->
        if !submitListEquals(prevProps.submits, @props.submits)
            @setState
                showBestSubmits: false
                commentText: ""

    setCurrentSubmit: (submit) ->
        @currentSubmit = submit

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
            @setState({commentText: newText})

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    paidStyle: () ->
        user = @props.user
        if (!user?.paidTill)
            styles.nonpaid
        else if isPaid(user)
            if user.userList == "stud"
                styles.paid
            else
                styles.nonpaid
        else if !isMuchUnpaid(user)
            styles.unpaid
        else
            styles.muchUnpaid

    setResult: (result) ->
        @syncSetOutcome(result)
        @props.handleDone?()

    syncSetOutcome: (result) ->
        await callApi "setOutcome/#{@currentSubmit._id}", {
            result,
            comment: @state.commentText
        }
        @props.syncHandleDone?()
        @props.handleReload()

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
            await callApi "setQuality/#{@currentSubmit._id}/#{quality}", {}
            @props.handleReload()

    toggleBestSubmits: (e) ->
        if e
            e.preventDefault()
        @setState
            showBestSubmits: not @state.showBestSubmits

    render:  () ->
        <div className={@paidStyle()}>
            {`<SubmitListWithDiff {...this.props} {...this.state} SubmitComponent={SubmitForReviewResults} PostSubmit={SubmitActions} setCurrentSubmit={this.setCurrentSubmit} accept={this.accept} ignore={this.ignore} disqualify={this.disqualify} comment={this.comment} setField={this.setField} setQuality={this.setQuality} toggleBestSubmits={this.toggleBestSubmits} downloadSubmits={this.downloadSubmits} setComment={this.setComment} copyTest={this.copyTest} headerClassName={this.paidStyle()}/>`}
        </div>

SubmitsAndSimilarMerger = (props) ->
    for submit in props.submits
        submit.similar = false
    newSubmits = props.submits
    if props.similar and Array.isArray(props.similar)
        for submit in props.similar
            submit.similar = true
        newSubmits = deepcopy(props.similar).reverse().concat(props.submits)
    `<ReviewResult  {...props} submits={newSubmits}/>`

options =
    urls: (props) ->
        result = 
            user: "user/#{props.result.fullUser._id}"
            me: "me"
        if not props.result.findMistake
            result.submits = "submits/#{props.result.fullUser._id}/#{props.result.fullTable._id}"
            result.bestSubmits = "bestSubmits/#{props.result.fullTable._id}"
        else
            result.submits = "submitsForFindMistake/#{props.result.fullUser._id}/#{props.result.findMistake}"
        return result

    timeout: 0

optionsForSimilar = 
    urls: (props) ->
        if props.submits and props.me?.admin
            similar: "similarSubmits/#{props.submits[props.submits.length - 1]?._id}"
        else
            {}
    propogateReload: true

export default ConnectedComponent(ConnectedComponent(SubmitsAndSimilarMerger, optionsForSimilar), options)
