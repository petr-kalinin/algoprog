React = require('react')

import Table from 'react-bootstrap/lib/Table'
import Button from 'react-bootstrap/lib/Button'
import Alert from 'react-bootstrap/lib/Alert'

import UserName from './UserName'

import callApi from '../lib/callApi'


SESSION_TIMES = ["14:00", "15:30"]

export default class Checkins extends React.Component
    constructor: (props) ->
        super(props)
        @register = @register.bind this
        @state = 
            result: undefined

    register: (i) ->
        () =>
            @setState
                result: undefined
            result = await callApi 'checkin', {session: i}
            await @props.handleReload()
            @setState
                result: result

    render: () ->
        wasme = [false, false]
        <div>
            <h1>Регистрация на занятие</h1>
            {
            if @state.result?.error
                <Alert bsStyle="danger">
                    Не удалось зарегистрироваться: {@state.result.error}
                </Alert>
            else if @state.result?.ok
                <Alert bsStyle="success">
                    Операция успешна
                </Alert>
            }
            {
            if @props.data?
                <div>
                    <Table condensed>
                        <thead><tr>
                        {
                        for time, i in SESSION_TIMES
                            <th key={time}>
                                <h2>Занятие в {time}</h2>
                                <p>Всего мест: {@props.data[i].max}</p>
                            </th>
                        }
                        </tr></thead>
                        <tbody>
                        {
                        rows = Math.max(@props.data[0].max, @props.data[1].max)
                        for row in [0...rows]
                            <tr key={row}>
                                {
                                for _, i in SESSION_TIMES
                                    <td key={i}>
                                        {
                                        if @props.data[i].checkins[row]
                                            if @props.data[i].checkins[row].user == @props.myUser?._id   
                                                wasme[i] = true
                                            <UserName user={@props.data[i].checkins[row].fullUser}/>
                                        else if row < @props.data[i].max
                                            <span>(свободно)</span>
                                        }                                            
                                    </td>
                                }
                            </tr>
                        }
                        <tr>
                            {
                            for _, i in SESSION_TIMES
                                <td key={i}>
                                    {
                                    if @props.myUser?._id and !wasme[i] and @props.data[i].checkins.length < @props.data[i].max
                                        <Button bsStyle="primary" onClick={@register(i)}>Зарегистрироваться</Button>
                                    }                                            
                                </td>
                            }
                        </tr>
                        </tbody>
                    </Table>
                    {
                    if wasme[0] or wasme[1]
                        <Button bsStyle="info" onClick={@register(null)}>Отменить регистрацию</Button>
                    }
                </div>
            }
        </div>
