React = require('react')

import Button from 'react-bootstrap/lib/Button'
import Form from 'react-bootstrap/lib/Form'

import FieldGroup from '../../components/FieldGroup'
import globalStyles from '../../components/global.css'
import callApi from '../../lib/callApi'

class SetContestTimeForm extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            time: 0
        @setField = @setField.bind this
        @submit = @submit.bind this

    setField: (field, value) ->
        newState = {}
        newState[field] = value
        @setState newState

    submit: () ->
        result = await callApi "setContestTime/#{@props.contestId}", {
            time: @state.time
        }
        @props.handleReload()

    render: () ->
        <Form inline onSubmit={@submit}>
            Установить витруальное время: {" "}
            <FieldGroup
                id="time"
                label=""
                componentClass="input"
                setField={@setField}
                state={@state}/>
            <Button onClick={@submit}>OK</Button>
        </Form>

startContest = (contestId, reload) ->
    () ->
        await callApi "startContest/#{contestId}", {}
        reload()

Header = (props) ->
    <div>
        {props.contestResult.virtualBlocked && 
            <div>
                <p>Этот контест виртуальный: нажмите кнопку, чтобы стартовать контест.</p>
                <Button type="submit" bsStyle="primary" onClick={startContest(props.contest._id, props.handleReload)}>
                    Начать виртуальный контест!
                </Button>
            </div>
        }
        {!props.contestResult.virtualBlocked && props.me?.admin &&
            <div>
                <SetContestTimeForm handleReload={props.handleReload} contestId={props.contest._id}/>
            </div>
        }
    </div>

PassedText = (props) ->
    if props.header
        return "Прошло"
    if not props.contestResult.startTime or +(new Date(props.contestResult.startTime)) == 0
        return ""
    passed = new Date() - new Date(props.contestResult.startTime)
    "#{Math.floor(passed / 60 / 1000)} мин."

UserAddInfoImpl = (props) ->
    <td className={globalStyles.mainTable_td}><PassedText {props...}/></td>

export default virtual = (cls) ->
    return class WithVirtualHeader extends cls
        Contest: () ->
            Super = super()
            (props) ->
                <div>
                    <Header {props...}/>
                    <Super {props...}/>
                </div>

        UserAddInfo: () ->
            Super = super()
            (props) ->
                [<Super {props...}/>,
                <UserAddInfoImpl {props...} />]
