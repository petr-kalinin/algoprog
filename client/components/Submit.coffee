React = require('react')
moment = require('moment')
iconv = require('iconv-lite')

import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import Table from 'react-bootstrap/lib/Table'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'

import {Link} from 'react-router-dom'

import UserName from './UserName'
import {getClassStartingFromJuly} from '../../client/lib/graduateYearToClass'

import outcomeToText from '../lib/outcomeToText'

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

Comment = (props) ->
    if props.comment.text
        text = "#{props.comment.text}\n-- #{props.comment.reviewer}"
    else    
        text = props.comment
    <pre dangerouslySetInnerHTML={{__html: text}}></pre>

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
    <div>
        <h3>{moment(props.submit.time).format('YYYY-MM-DD kk:mm:ss')}</h3>
        <h1><UserName user={props.submit.fullUser}/>
            {props.admin && " (#{getClassStartingFromJuly(props.submit.fullUser.graduateYear)}, #{props.submit.fullUser.level.current}, #{props.submit.fullUser.userList}), " || ", "}
            <Link to={"/material/#{props.submit.problem}"}>{props.submit.fullProblem.name}</Link>{": "}
            {message}
        </h1>
        <h4>{props.submit.fullProblem.tables.join("\n")}</h4>
    </div>

export default class Submit extends React.Component
    render: () ->
        [cl, message] = outcomeToText(@props.submit.outcome)
        admin = @props.me?.admin
        <div>
            {@props.showHeader && <SubmitHeader submit={@props.submit} admin={admin}/>}
            <Tabs defaultActiveKey={1} id="submitTabs">
                <Tab eventKey={1} title="Исходный код">
                    <SubmitSource submit={@props.submit} />
                </Tab>
                <Tab eventKey={2} title="Комментарии">
                    {
                    res = []
                    a = (el) -> res.push(el)
                    for comment, index in (@props.submit?.comments || [])
                        a <Comment key={index} comment={comment}/>
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
                                a <tr key={index}>
                                    <td>{index}</td>
                                    <td>{result.string_status}</td>
                                    <td>{result.time/1000}</td>
                                    <td>{result.max_memory_used}</td>
                                </tr>
                            res}
                        </tbody>
                    </Table>
                </Tab>
            </Tabs>
        </div>
