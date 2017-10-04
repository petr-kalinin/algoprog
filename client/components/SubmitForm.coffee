React = require('react')
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

import {callApiWithBody} from '../lib/callApi'

import FieldGroup from './FieldGroup'

import ConnectedComponent from '../pages/ConnectedComponent'

LANGUAGES = [
    [27, "Python 3.4.3", "py", "py3"]
    [1, "Free Pascal 2.6.4", "pas"]
    [30, "PascalABC 3.1.0.1198"]
    [3, "GNU C++ 5.3.1", "cpp"]
    [2, "GNU C 5.3.1"]
    [8, "Borland Delphi 6 - 14.5"]
    [18, "Java JDK 1.8"]
    [22, "PHP 5.6.19"]
    [23, "Python 2.7.10"]
    [24, "Perl 5.22.1"]
    [25, "Mono C# 4.0.5"]
    [26, "Ruby 2.2.4"]
    [28, "Haskell GHC 7.8.4"]
    [29, "FreeBASIC 1.05.0"]
    [68, "GNU C++ 5.3.1 + sanitizer"]
]

class SubmitForm extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            lang_id: ""
        @setField = @setField.bind(this)
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

    submit: (event) ->
        event.preventDefault()
        newState = {
            @state...
            submit:
                loading: true
        }
        @setState(newState)
        try
            formData = new FormData(document.getElementById("submitForm"))
            data = await callApiWithBody "submit/#{@props.problemId}", 'POST', {}, formData
            if data.submit
                data =
                    submit:
                        result: true
                @props.reloadSubmitList()
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
            if @state.submit?.result
                <Alert bsStyle="success">
                    Решение успешно отправлено.
                </Alert>
            }
            {
            if @state.submit?.error
                <Alert bsStyle="danger">
                    Ошибка отправки. Возможно, вы уже сдавали это решение.
                </Alert>
            }
        </div>

export default ConnectedComponent(SubmitForm)
