React = require('react')

import Button from 'react-bootstrap/lib/Button'

import FieldGroup from './FieldGroup'
import ConnectedComponent from '../lib/ConnectedComponent'

import callApi from '../lib/callApi'

class SimplePage extends React.Component
    updatePreElements: () =>
        preElements = @statementEl.querySelectorAll("pre")
        preElements.forEach (preElement) ->
            copyBtn = document.createElement "button"
            copyBtn.className = "btn btn-default btn-xs"
            copyBtn.appendChild document.createTextNode "скопировать"
            copyBtn.onclick = () =>
                navigator.clipboard.writeText preElement.innerText
                copyBtn.textContent = "скопировано"
                copyBtn.className = "btn btn-success btn-xs"
                clearSuccess = () => 
                    copyBtn.className = "btn btn-default btn-xs"
                    copyBtn.textContent = "скопировать"
                setTimeout clearSuccess, 1000
            preElement.before(copyBtn)

    componentDidMount: () =>
        @updatePreElements()

    componentDidUpdate: (prevProps) =>
        if @props.material.text != prevProps.material.text
            @updatePreElements()

    render: () ->
        <div>
            <div dangerouslySetInnerHTML={{__html: @props.material.text}} ref={(el) => @statementEl = el}>
            </div>
        </div>

class EditablePage extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            isEditing: false
            text: @props.material.text
            title: @props.material.title
        @setEditing = @setEditing.bind this
        @setField = @setField.bind this
        @submit = @submit.bind this

    setField: (field, value) ->
        newState = {}
        newState[field] = value
        @setState newState

    setEditing: (value) ->
        @setState
            isEditing: value

    submit: () ->
        @setState
            isEditing: false
        result = await callApi "editMaterial/#{@props.material._id}", {
            text: @state.text
            title: @state.title
        }
        @props.reloadMaterial()

    componentDidUpdate: () ->
        if not @state.isEditing and (@state.text != @props.material.text or @state.title != @props.material.title)
            @setState
                text: @props.material.text
                title: @props.material.title

    render: () ->
        if not @props.me?.admin
            return <SimplePage material={@props.material}/>
        if @state.isEditing
            <div>
                <FieldGroup
                    id="title"
                    label="Заголовок"
                    componentClass="input"
                    setField={@setField}
                    state={@state}/>
                <FieldGroup
                    id="text"
                    label="Текст"
                    componentClass="textarea"
                    setField={@setField}
                    style={{ height: 400 }}
                    state={@state}/>
                <Button onClick={@submit}>OK</Button>
            </div>
        else
            <div>
                <SimplePage material={@props.material}/>
                <Button onClick={ => @setEditing(true)}>Редактировать</Button>
            </div>

options =
    urls: (props) ->
        me: "me"

export default ConnectedComponent(EditablePage, options)
