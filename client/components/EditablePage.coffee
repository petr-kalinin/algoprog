React = require('react')

import Button from 'react-bootstrap/lib/Button'

import FieldGroup from './FieldGroup'
import ConnectedComponent from '../lib/ConnectedComponent'

import callApi from '../lib/callApi'

class SimplePage extends React.Component
    componentDidMount: () =>
        preses = @dangerEl.querySelectorAll("pre")
        preses.forEach (pre) ->
            copy = document.createElement "button"
            copy.className = "btn btn-secondary"
            copy.appendChild document.createTextNode "скопировать"
            copy.onclick = () =>
                navigator.clipboard.writeText pre.textContent
            pre.after(copy)

    render: () ->
        <div>
            <div dangerouslySetInnerHTML={{__html: @props.material.content}} ref={(el) => @dangerEl = el}>
            </div>
        </div>

class EditablePage extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            isEditing: false
            content: @props.material.content
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
            content: @state.content
            title: @state.title
        }
        @props.reloadMaterial()

    componentDidUpdate: () ->
        if not @state.isEditing and (@state.content != @props.material.content or @state.title != @props.material.title)
            @setState
                content: @props.material.content
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
                    id="content"
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
