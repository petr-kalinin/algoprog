React = require('react')
FontAwesome = require('react-fontawesome')
PromiseFileReader = require('promise-file-reader')

import { connect } from 'react-redux'

import Alert from 'react-bootstrap/lib/Alert'
import Grid from 'react-bootstrap/lib/Grid'
import Form from 'react-bootstrap/lib/Form'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import HelpBlock from 'react-bootstrap/lib/HelpBlock'
import Button from 'react-bootstrap/lib/Button'

import Loader from '../components/Loader'

import callApi, {callApiWithBody} from '../lib/callApi'

import Editor from './Editor'
import FieldGroup from './FieldGroup'
import ShadowedSwitch from './ShadowedSwitch'

import ConnectedComponent from '../lib/ConnectedComponent'

import LANGUAGES from '../lib/languages'

class SubmitForm extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            lang_id: Object.keys(LANGUAGES)[1]
            draft: false
            editorOn: @props.myUser.prefs?.editorOn
        @setField = @setField.bind(this)
        @toggleDraft = @toggleDraft.bind(this)
        @toggleEditor = @toggleEditor.bind(this)
        @submit = @submit.bind(this)
        @handleEditorDidMount = @handleEditorDidMount.bind(this)
        @editorRef = React.createRef()
        @setStartLanguage = @setStartLanguage.bind(this)
        @setStartLanguage()

    handleEditorDidMount: (_, editor) ->
        @editorRef.current = editor
        @props.editorDidMount?(_, editor)

    setField: (field, value) ->
        newState = {@state...}
        if field == "file"
            newState.wasFile = true
            for key, lang of LANGUAGES
                for candidate in lang.extensions
                    if value.endsWith(candidate)
                        newState["lang_id"] = key
        else  # file input is not controlled
            newState[field] = value
        @setState(newState)

    toggleDraft: () ->
        newState = {
            draft: !@state.draft
            submit: undefined
        }
        @setState(newState)

    toggleEditor: () ->
        @setState
            editorOn: not @state.editorOn

    setStartLanguage: () ->
        if @props.startLanguage
            for lang of LANGUAGES
                if @props.startLanguage.includes(lang)
                    @state.lang_id = lang
                    break

    componentDidUpdate: (prevProps, prevState) ->
        if prevProps.problemId != @props.problemId
            @setState
                submit: undefined
                editorOn: false
                draft: false
            @editorRef.current = undefined
        if prevProps.startLanguage != @props.startLanguage
            @setStartLanguage()


    submit: (event) ->
        event.preventDefault()
        newState = {
            @state...
            submit:
                loading: true
        }
        @setState(newState)
        try
            if @props.editorOn || @state.editorOn
                text = @editorRef.current.getValue()
                enc = new TextEncoder()
                fileText = Array.from(enc.encode(text))
            else
                fileName = document.getElementById("file").files[0]
                fileText = await PromiseFileReader.readAsArrayBuffer(fileName)
                fileText = Array.from(new Uint8Array(fileText))
            dataToSend =
                language: @state.lang_id
                code: fileText
                draft: @state.draft
                findMistake: @props.findMistake
            if not @props.editorOn
                dataToSend.editorOn = @state.editorOn
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
            else if data.unpaid
                data = 
                    submit:
                        error: true
                        message: "Ваш аккаунт заблокирован за неуплату"
            else if data.dormant
                data = 
                    submit:
                        error: true
                        message: "Ваш аккаунт не активирован"
            else
                throw ""
        catch e
            data =
                submit:
                    error: true
                    message: "Неопознанная ошибка"
        newState = {
            @state...
            wasFile: false
            submit: data.submit
        }
        @setState(newState)
        document.getElementById("file")?.value = ""

    render: () ->
        if not @props.myUser?._id
            return null

        # TODO: merge @props.noFile and @props.editorOn?
        canSubmit = (not @state.submit?.loading) and (@state.wasFile || @props.editorOn || @state.editorOn)
        if @props.canSubmit?
            canSubmit = canSubmit and @props.canSubmit

        <div>
            {(@props.editorOn || @state.editorOn) && <Editor language={@state.lang_id} editorDidMount={@handleEditorDidMount} value={@editorRef.current?.getValue() || @props.editorValue}/>}
            <h4>Отправить решение</h4>
            <Form inline onSubmit={@submit} id="submitForm">
                {(@props.noFile || @state.editorOn) || <FieldGroup
                    id="file"
                    label=""
                    type="file"
                    setField={@setField}
                    state={@state}/>}
                {if !@props.material.isReview
                    <FieldGroup
                        id="lang_id"
                        label=""
                        componentClass="select"
                        setField={@setField}
                        state={@state}>
                        {Object.keys(LANGUAGES).map((key) =>
                            id = LANGUAGES[key][@props.material.testSystemData.system]
                            if id
                                <option value={key} key={key}>{key}</option>
                            else
                                null
                        )}
                    </FieldGroup>
                }
                {@props.editorOn || <>{" "}
                    <span onClick={@toggleEditor} title="Редактор кода">
                        <ShadowedSwitch on={@state.editorOn}>
                            <FontAwesome name={"pencil-square" + if @state.editorOn then "" else "-o"} />
                        </ShadowedSwitch>
                    </span>
                </>
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
                        <Loader size={10} />
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
