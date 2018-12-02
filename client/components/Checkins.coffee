React = require('react')

import Table from 'react-bootstrap/lib/Table'
import Button from 'react-bootstrap/lib/Button'
import Alert from 'react-bootstrap/lib/Alert'
import Panel from 'react-bootstrap/lib/Panel'

import UserName from './UserName'

import callApi from '../lib/callApi'


SESSION_TIMES = ["14:00", "15:30"]

export default class Checkins extends React.Component
    constructor: (props) ->
        super(props)
        @register = @register.bind this
        @state = 
            result: undefined

    register: (i, userId) ->
        () =>
            @setState
                result: undefined
            result = await callApi "checkin/#{userId}", {session: i}
            await @props.handleReload()
            @setState
                result: result

    canRegister: () ->
        @props.myUser.rating > 0

    render: () ->
        wasme = [false, false]
        <div>
            <h1>Регистрация на занятие</h1>
            <p>
            Можно записываться на одно любое занятие, занятия ничем не отличаются.
            Если вы записались, но прийти не сможете — удалите себя из списка.
            </p>

            <p>
            <b>Новичкам (кто не решил в курсе ни одной задачи) приходить на занятие нельзя</b>.
            Надо начать сдавать задачи заочно — 
            если хотя бы одну решите, можете записываться и приходить уже не как новички.
            </p>

            <p>
            Можно приходить без записи, но компьютеры будут выдаваться в первую очередь тем,
            кто записался (даже если они опаздывают).</p>
            
            <p>
            Записываться сразу на оба занятия нельзя, 
            но если записаться на 14.00, то при наличии свободных мест можно остаться и на второе занятие.
            Аналогично, можно записаться на 15.30, придти раньше и при наличии мест я вас пущу. 
            Но будьте готовы к тому, что мест может не быть. 
            </p>

            <p>
            Тем, кто со своими ноутбуками, записываться не надо, просто приходите
            и можете оставаться на два занятия.
            </p>

            <p>
            Не забудьте с собой паспорт (если паспорта еще нет, то свидетельство о рождении) -- его могут спросить охранники на входе!                    
            </p>

            <Alert bsStyle="danger">
                Занятия 9 декабря не будет. Ниже — запись на 16 декабря.
            </Alert>

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
                                            <div>
                                            <UserName user={@props.data[i].checkins[row].fullUser}/>
                                            {
                                            if @props.me?.admin
                                                <button type="button" 
                                                        className="close pull-left"
                                                        onClick={@register(null, @props.data[i].checkins[row].user)}>
                                                    <span>&times;&nbsp;</span>
                                                </button>
                                            }
                                            </div>
                                        else if row < @props.data[i].max
                                            <span>(свободно)</span>
                                        }                                            
                                    </td>
                                }
                            </tr>
                        }
                        {
                        if @canRegister()
                            <tr>
                                {
                                for _, i in SESSION_TIMES
                                    <td key={i}>
                                        {
                                        if @props.myUser?._id and !wasme[i] and @props.data[i].checkins.length < @props.data[i].max
                                            <Button bsStyle="primary" onClick={@register(i, @props.myUser?._id)}>
                                                Зарегистрироваться
                                            </Button>
                                        }                                            
                                    </td>
                                }
                            </tr>
                        }
                        </tbody>
                    </Table>
                    {
                    if wasme[0] or wasme[1]
                        <Button bsStyle="info" onClick={@register(null, @props.myUser?._id)}>Отменить регистрацию</Button>
                    else if !@canRegister()
                        <Alert bsStyle="danger">
                            Чтобы зарегистрироваться на занятие, вам надо решить минимум одну задачу. 
                        </Alert>
                    }
                </div>
            }
        </div>
