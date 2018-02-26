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

import outcomeToText from '../lib/outcomeToText'

LANGUAGES =
    "Python 3.4.3": "Python",
    "Free Pascal 2.6.4": "Delphi",
    "PascalABC 3.1.0.1198": "Delphi",
    "GNU C++ 5.3.1": "cpp",
    "GNU C 5.3.1": "cpp",
    "Borland Delphi 6 - 14.5": "Delphi",
    "Java JDK 1.8": "Java"
    "PHP 5.6.19": "PHP",
    "Python 2.7.10": "Python",
    "Perl 5.22.1": "Perl",
    "Mono C# 4.0.5": "cs",
    "Ruby 2.2.4": "Ruby",
    "Haskell GHC 7.8.4": "Haskell",
    "FreeBASIC 1.05.0": "Basic",
    "GNU C++ 5.3.1 + sanitizer": "cpp"

langClass = (lang) ->
    if lang of LANGUAGES
        return LANGUAGES[lang]
    else
        return ""

convert = (source, encoding) ->
    buf = Buffer.from(source, "latin1")
    return iconv.decode(buf, encoding)

ENCODINGS = ["utf8", "win1251", "cp866"]

export default class Submit extends React.Component
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
        [cl, message] = outcomeToText(@props.submit.outcome)
        admin = @props.me?.admin
        <div>
            {@props.showHeader &&
                <div>
                    <h3>{moment(@props.submit.time).format('YYYY-MM-DD kk:mm:ss')}</h3>
                    <h1><UserName user={@props.submit.fullUser}/>
                        {admin && " (#{@props.submit.fullUser.level.current}, #{@props.submit.fullUser.userList}), " || ", "}
                        <Link to={"/material/#{@props.submit.problem}"}>{@props.submit.fullProblem.name}</Link>{": "}
                        {message}
                    </h1>
                    <h4>{@props.submit.fullProblem.tables.join("\n")}</h4>
                </div>}
            <Tabs defaultActiveKey={1} id="submitTabs">
                <Tab eventKey={1} title="Исходный код">
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
