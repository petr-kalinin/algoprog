React = require('react')
FontAwesome = require('react-fontawesome')
PromiseFileReader = require('promise-file-reader')

import { CometSpinLoader } from 'react-css-loaders';
import { connect } from 'react-redux'

import Alert from 'react-bootstrap/lib/Alert'
import Grid from 'react-bootstrap/lib/Grid'
import Form from 'react-bootstrap/lib/Form'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import HelpBlock from 'react-bootstrap/lib/HelpBlock'
import Button from 'react-bootstrap/lib/Button'

import callApi, {callApiWithBody} from '../lib/callApi'

import FieldGroup from './FieldGroup'
import ShadowedSwitch from './ShadowedSwitch'

import ConnectedComponent from '../lib/ConnectedComponent'

LANGUAGES = [
    [27, "Python 3.6.4", "py", "py3"]
    [1, "Free Pascal 3.0.2", "pas"]
    [30, "PascalABC 3.1.0.1198"]
    [3, "GNU C++ 7.2.0", "cpp"]
    [2, "GNU C 7.2.0"]
    [8, "Borland Delphi 6 - 14.5"]
    [18, "Java JDK 1.8"]
    [22, "PHP 7.1.13"]
    [23, "Python 2.7.10"]
    [24, "Perl 5.26.1"]
    [25, "Mono C# 4.8"]
    [26, "Ruby 2.4.3"]
    [28, "Haskell GHC 8.0.2"]
    [29, "FreeBASIC 1.05.0"]
    [68, "GNU C++ 5.3.1 + sanitizer"]
]

class SubmitForm extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            lang_id: ""
            draft: false
        @setField = @setField.bind(this)
        @toggleDraft = @toggleDraft.bind(this)
        @submit = @submit.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        if field == "file"
            newState.wasFile = true
            for lang in LANGUAGES
                for candidate in lang
                    if value.endsWith(candidate)
                        newState["lang_id"] = lang[0]
        else  # file input is not controlled
            newState[field] = value
        @setState(newState)

    toggleDraft: () ->
        newState = {
            draft: !@state.draft
            submit: undefined
        }
        @setState(newState)

    componentDidUpdate: (prevProps, prevState) ->
        if prevProps.problemId != @props.problemId
            @setState
                submit: undefined

    submit: (event) ->
        event.preventDefault()
        newState = {
            @state...
            submit:
                loading: true
        }
        @setState(newState)
        try
            fileName = document.getElementById("file").files[0]
            fileText = await PromiseFileReader.readAsArrayBuffer(fileName)
            fileText = Array.from(new Uint8Array(fileText))
            languageName = undefined
            for lang in LANGUAGES
                if @state.lang_id == lang[0]
                    languageName = lang[1]
            dataToSend =
                language: languageName
                code: fileText
                draft: @state.draft
            url = "submit/#{@props.problemId}"
            data = await callApi url, dataToSend

            if data.submit
                data =
                    submit:
                        result: true
                @props.reloadSubmitList()
            else if data.error == "duplicate"
                data = 
                    submit:
                        error: true
                        message: "Вы уже отправляли это код"
            else
                throw ""
        catch
            data =
                submit:
                    error: true
                    message: "Неопознанная ошибка"
        newState = {
            @state...
            submit: data.submit
        }
        @setState(newState)

    render: () ->
        if not @props.myUser?._id
            return null

        canSubmit = (not @state.submit?.loading) and (@state.wasFile)

        <div>
            <h4>Отправить решение</h4>
            <Form inline onSubmit={@submit} id="submitForm">
                <FieldGroup
                    id="file"
                    label=""
                    type="file"
                    setField={@setField}
                    state={@state}/>
                {if !@props.material.isReview
                    <FieldGroup
                        id="lang_id"
                        label=""
                        componentClass="select"
                        setField={@setField}
                        state={@state}>
                        {LANGUAGES.map((lang) =>
                            <option value={lang[0]} key={lang[0]}>{lang[1]}</option>
                        )}
                    </FieldGroup>
                }
                {" "}
                <span onClick={@toggleDraft} title="Не тестировать, отправить как черновик">
                    <ShadowedSwitch on={@state.draft}>
                        <FontAwesome name={"hourglass" + if @state.draft then "" else "-o"} />
                    </ShadowedSwitch>
                </span>
                {" "}
                {
                if @state.submit?.loading
                    <div style={display: "inline-block", position: "relative", top: "72px", marginTop: "-144px", width: "30px"}>
                        <CometSpinLoader size={10} />
                    </div>
                }
                <Button type="submit" bsStyle="primary" disabled={!canSubmit}>
                    Отправить
                </Button>
            </Form>
            {
            if @state.draft
                <Alert bsStyle="info">
                    Решение будет отправлено как черновик. Оно будет сохранено на сервере и доступно в списке посылок,
                    но не будет протестировано и не будет влиять на результаты по этой задаче.
                    Например, это вам может быть полезно, если вы хотите продолжить работу над задачей
                    с другого компьютера.
                </Alert>
            }
            {
            if @state.submit?.result
                <Alert bsStyle="success">
                    Решение успешно отправлено.
                </Alert>
            }
            {
            if @state.submit?.error
                <Alert bsStyle="danger">
                    Ошибка отправки: {@state.submit.message}
                </Alert>
            }
        </div>

options =
    urls: () ->
        { "myUser" }

export default ConnectedComponent(SubmitForm, options)
