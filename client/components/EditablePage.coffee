React = require('react')

import Button from 'react-bootstrap/lib/Button'

import FieldGroup from './FieldGroup'
import ConnectedComponent from '../lib/ConnectedComponent'

import callApi from '../lib/callApi'

copy2clipboardcode = () ->
    'ondblclick="copyText=this.textContent;textArea=document.createElement(\'textarea\');textArea.textContent=copyText;document.body.append(textArea);textArea.select();document.execCommand(\'copy\');"'

addCopy2Clipboard = (content) ->
    ind = content.lastIndexOf("sample-tests")
    if ind > 0
        part1 = content.substring(0, ind)
        part2 = content.substring(ind, content.length)
    else
        part1 = ''
        part2 = content
    ind = part2.indexOf("<pre")
    while ind >= 0
        part3 = part2.substring(0, ind + 5)
        part1 = part1 + part3 + copy2clipboardcode() + " "
        part2 = part2.substring(ind + 5)
        ind = part2.indexOf("<pre")
    part1 + " " + part2

SimplePage = (props) ->
    <div>
        <div dangerouslySetInnerHTML={{__html: addCopy2Clipboard(props.material.content)}}>
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
