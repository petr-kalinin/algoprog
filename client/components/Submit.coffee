React = require('react')
moment = require('moment')
FontAwesome = require('react-fontawesome')

import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import Table from 'react-bootstrap/lib/Table'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'
import Grid from 'react-bootstrap/lib/Grid'
import Col from 'react-bootstrap/lib/Col'

import {Link} from 'react-router-dom'
import { LinkContainer } from 'react-router-bootstrap'

import {LangRaw} from '../lang/lang'

import {getClassStartingFromJuly} from '../lib/graduateYearToClass'
import outcomeToText from '../lib/outcomeToText'
import toUtf8 from '../lib/toUtf8'
import withLang from '../lib/withLang'

import {DiffEditor} from './Editor'
import UserName from './UserName'

import styles from './Submit.css'

LANGUAGE_TO_HIGHLIGHT_STYLE =
    "Python": "python",
    "Pascal": "delphi",
    "C++": "cpp",
    " C": "cpp",  # space important
    "Delphi": "delphi",
    "Java": "java"
    "PHP": "php",
    "Perl": "perl",
    "C#": "cs",
    "Ruby": "ruby",
    "Haskell": "haskell",
    "BASIC": "basic",

langClass = (lang) ->
    for l, style of LANGUAGE_TO_HIGHLIGHT_STYLE
        if lang && lang.includes(l)
            return style
    return ""

class SubmitSource extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            copied: false
        @copy = @copy.bind this

    copy: () ->
        (e) =>
            navigator.clipboard.writeText @props.submit.sourceRaw
            @setState
                copied: true

    componentDidMount: ->
        @doHighlight()

    componentDidUpdate:  (prevProps, prevState) ->
        if @props.submit._id != prevProps.submit._id
            @state =
                copied: false
            @doHighlight()

    doHighlight: ->
        for el in document.getElementsByClassName("sourcecode")
            hljs.highlightBlock(el)

    render: () ->
        copyClass = if @state.copied then "success" else "default"
        copyText = if @state.copied then LangRaw("copied", @props.lang) else LangRaw("copy", @props.lang)
        source = toUtf8(@props.submit.source)
        <div>
            <pre dangerouslySetInnerHTML={{__html: source}} className={"sourcecode " + langClass(@props.submit.language)}></pre>
            <ButtonGroup>
                <Button bsStyle={copyClass} bsSize="xsmall" onClick={@copy()}>{copyText}</Button>
                <LinkContainer to={"/api/submitSource/#{@props.submit._id}"}>
                    <Button bsStyle="default" bsSize="xsmall">
                        {LangRaw("download", @props.lang)}
                    </Button>
                </LinkContainer>
            </ButtonGroup>
        </div>

export SubmitSource = withLang SubmitSource

export SubmitHeader = (props) ->
    [cl, message] = outcomeToText(props.submit.outcome)
    <div className={(if props.sticky then styles.stickyHeader else "") + " " + (props.className || "")}>
        <h3>{moment(props.submit.time).format('YYYY-MM-DD kk:mm:ss')}</h3>
        <h1>{props.submit.fullUser && <UserName user={props.submit.fullUser}/>}
            {props.admin && " (#{getClassStartingFromJuly(props.submit.fullUser?.graduateYear)}, #{props.submit.fullUser?.level?.current}, #{props.submit.fullUser?.userList}), " || ", "}
            <Link to={"/material/#{props.submit.problem}"}>{props.submit.fullProblem.name}</Link>{": "}
            {message}
        </h1>
        <h4>{props.submit.fullProblem.tables.join("\n")}</h4>
    </div>

getClassName = (status) ->
    switch status
        when "OK" then "success"
        when "Превышен предел времени", "Превышено максимальное время работы", "Превышено максимальное общее время работы", "TIME_LIMIT_EXCEEDED" then "info"
        else styles.wa

class TestResult extends React.Component
    constructor: (props) ->
        super(props)
        @state = 
            open: false
        @toggle = @toggle.bind(this)

    toggle: () ->
        @setState
            open: not @state.open

    render: () ->
        canToggle = "input" of @props.result
        res = []
        status = @props.result.string_status
        if @props.result.checker_output
            status = @props.result.checker_output.substr(0, 70)
        classname = getClassName(@props.result.string_status)
        res.push <tr className={if canToggle then styles.toggling else ""} onClick={@toggle} key="1" width="100%" className={classname} title={@props.result.string_status}>
            <td>{@props.index}{" "}
                {@props.copyTest && <span onClick={@props.copyTest(@props.result)}><FontAwesome name="chevron-circle-down"/></span>}
            </td>
            <td className={styles.status}><span>{status}</span></td>
            <td>{@props.result.time/1000}</td>
            <td>{@props.result.max_memory_used}</td>
        </tr>
        if canToggle and @state.open
            editorDidMount = (orig, modif, e) =>
                h1 = e.getOriginalEditor().getContentHeight();
                h2 = e.getModifiedEditor().getContentHeight();
                h = Math.min(300, Math.max(h1, h2))
                document.getElementById(styles.diffEditor + "_" + @props.index).style.height = h
                e.layout()

            res.push <tr key="2"><td colSpan="4" className={styles.td}>
                <Grid fluid>
                    <Col xs={12} sm={12} md={6} lg={6}>
                        Input:
                        <pre>{@props.result.input}</pre>
                    </Col>
                    <Col xs={12} sm={12} md={6} lg={6}>
                        Checker:
                        <pre>{@props.result.checker_output}</pre>
                        Stderr:
                        <pre>{@props.result.error_output}</pre>
                    </Col>
                </Grid>
                <Grid fluid>
                    <Col xs={12} sm={12} md={12} lg={12}>
                        Left: answer, right: output
                        <div id={styles.diffEditor + "_" + @props.index}>
                            <DiffEditor original={@props.result.corr} modified={@props.result.output} editorDidMount={editorDidMount} height={null}/>
                        </div>
                    </Col>
                </Grid>
            </td></tr>
        return res

class Submit extends React.Component
    constructor: (props) ->
        super(props)

    render: () ->
        [cl, message] = outcomeToText(@props.submit.outcome)
        admin = @props.me?.admin
        <div>
            {@props.showHeader && <SubmitHeader submit={@props.submit} admin={admin} sticky={@props.headerSticky} className={@props.headerClassName}/>}
            <Tabs defaultActiveKey={1} id="submitTabs">
                <Tab eventKey={1} title={LangRaw("source_code", @props.lang)}>
                    <SubmitSource submit={@props.submit} />
                </Tab>
                <Tab eventKey={2} title={LangRaw("comments", @props.lang)}>
                    {
                    res = []
                    a = (el) -> res.push(el)
                    for comment, index in (@props.submit?.comments || [])
                        a <pre key={index} dangerouslySetInnerHTML={{__html: comment}}></pre>
                    res}
                </Tab>
                <Tab eventKey={3} title={LangRaw("results", @props.lang)}>
                    <h4>{LangRaw("compiler_output", @props.lang)}</h4>
                    {
                    if @props.submit.results?.compiler_output
                        <pre dangerouslySetInnerHTML={{__html: @props.submit.results?.compiler_output}}/>
                    else
                        <pre>
                            {@props.submit.results?.protocol}
                        </pre>
                    }
                    <Table striped bordered condensed hover responsive>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>{LangRaw("result", @props.lang)}</th>
                                <th>{LangRaw("time", @props.lang)}</th>
                                <th>{LangRaw("memory", @props.lang)}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {
                            res = []
                            a = (el) -> res.push(el)
                            for index, result of (@props.submit.results?.tests || [])
                                a <TestResult key={index} result={result} index={index} copyTest={@props.copyTest}/>
                            res}
                        </tbody>
                    </Table>
                </Tab>
            </Tabs>
        </div>

export default withLang Submit