React = require('react')
moment = require('moment')
iconv = require('iconv-lite')
FontAwesome = require('react-fontawesome')

import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import Table from 'react-bootstrap/lib/Table'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'
import Grid from 'react-bootstrap/lib/Grid'
import Col from 'react-bootstrap/lib/Col'

import {Link} from 'react-router-dom'

import {getClassStartingFromJuly} from '../lib/graduateYearToClass'
import outcomeToText from '../lib/outcomeToText'

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

convert = (source, encoding) ->
    if not source
        return ""
    buf = Buffer.from(source, "latin1")
    return iconv.decode(buf, encoding)

ENCODINGS = ["utf8", "win1251", "cp866"]

export class SubmitSource extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            encoding: ENCODINGS[0]
        @setEncoding = @setEncoding.bind this

    setEncoding: (encoding) ->
        (e) =>
            e.preventDefault()
            @setState
                encoding: encoding

    componentDidMount: ->
        @doHighlight()

    componentDidUpdate:  (prevProps, prevState) ->
        if @props.submit._id != prevProps.submit._id or prevState.encoding != @state.encoding
            @doHighlight()

    doHighlight: ->
        for el in document.getElementsByClassName("sourcecode")
            hljs.highlightBlock(el)

    render: () ->
        <div>
            <pre dangerouslySetInnerHTML={{__html: convert(@props.submit.source, @state.encoding)}} className={"sourcecode " + langClass(@props.submit.language)}></pre>
            Кодировка:{" "}
            <ButtonGroup>
                {
                ENCODINGS.map (encoding) =>
                    <Button active={encoding==@state.encoding} onClick={@setEncoding(encoding)} key={encoding}>
                        {encoding}
                    </Button>
                }
            </ButtonGroup>
            <div><a href={"/api/submitSource/#{@props.submit._id}"}>Скачать</a></div>
        </div>

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
        res.push <tr className={if canToggle then styles.toggling else ""} onClick={@toggle} key="1">
            <td>{@props.index}{" "}
                {@props.copyTest && <span onClick={@props.copyTest(@props.result)}><FontAwesome name="chevron-circle-down"/></span>}
            </td>
            <td>{@props.result.string_status}</td>
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

export default class Submit extends React.Component
    constructor: (props) ->
        super(props)

    render: () ->
        [cl, message] = outcomeToText(@props.submit.outcome)
        admin = @props.me?.admin
        <div>
            {@props.showHeader && <SubmitHeader submit={@props.submit} admin={admin} sticky={@props.headerSticky} className={@props.headerClassName}/>}
            <Tabs defaultActiveKey={1} id="submitTabs">
                <Tab eventKey={1} title="Исходный код">
                    <SubmitSource submit={@props.submit} />
                </Tab>
                <Tab eventKey={2} title="Комментарии">
                    {
                    res = []
                    a = (el) -> res.push(el)
                    for comment, index in (@props.submit?.comments || [])
                        a <pre key={index} dangerouslySetInnerHTML={{__html: comment}}></pre>
                    res}
                </Tab>
                <Tab eventKey={3} title="Результаты">
                    <h4>Вывод компилятора</h4>
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
                                <th>Результат</th>
                                <th>Время</th>
                                <th>Память</th>
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
