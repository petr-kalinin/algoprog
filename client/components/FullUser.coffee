React = require('react')
import Button from 'react-bootstrap/lib/Button'

import UserBadge from './UserBadge'
import SolvedByWeek from './SolvedByWeek'
import ContributeByWeekCalendar from './ContributeByWeekCalendar'
import SubmitListTable from './SubmitListTable'
import Table from './Table'

import { Badge } from 'react-bootstrap'

import {LangRaw} from '../lang/lang'

import callApi from '../lib/callApi'
import ConnectedComponent from '../lib/ConnectedComponent'
import GROUPS from '../lib/groups'
import withLang from '../lib/withLang'

import globalStyles from './global.css'
import styles from './FullUser.css'

Chocos = (props) ->
    <div>
        <h2>Шоколадки</h2>
        <p className={global.small}>
            Первая строка: шоколадки за полные контесты: первая шоколадка за первый сданный полностью контест и далее по одной шоколадке каждый раз, когда число сданных контестов делится на три.
            Вторая строка: шоколадки за чистые контесты: за каждый контест, полностью сданный с первой попытки, одна шоколадка.
            Третья строка: шоколадки за почти чистые контесты: по шоколадке за каждые два контеста, в которых все задачи сданы не более чем со второй попытки, и при этом хотя бы одна задача сдана не с первой попытки.
        </p>
        <table className={styles.chocos_table}>
            <tbody>
                {
                res = []
                a = (el) -> res.push(el)
                for number, ci in props.chocos
                    a <tr key={ci}>
                        <td className={styles.chocos_td}>
                            {
                            rres = []
                            aa = (el) -> rres.push(el)
                            if number
                                for n in [1..number]
                                    suffix = ""
                                    if n <= props.chocosGot[ci]
                                        suffix = "-light"
                                    aa <img src={"/choco#{suffix}.png"} key={n} onClick={props.onClick(ci, n)}/>
                            else
                                aa <img src="/choco-strut.png"/>
                            rres
                            }
                        </td>
                        <td onClick={props.onClick(ci, 0)}>
                            <Badge>
                                {if props.chocosGot[ci] < number then " #{number - props.chocosGot[ci]} / " else null}
                                {number}
                            </Badge>
                        </td>
                    </tr>
                res}
            </tbody>
        </table>
    </div>

class SubmitsOnDay extends React.Component
    render: () ->
      # inline-block shrinks table to its content size
      <div style={display: "inline-block"}>
          <SubmitListTable submits={@props.data} showProblems={true} />
      </div>

SubmitsOnDayConnected = ConnectedComponent(SubmitsOnDay, {urls: (props) -> (data: "submitsByDay/#{props.userId}/#{props.day}")})

class FullUser extends React.Component
    constructor: (props) ->
        super(props)
        @setChocosGot = @setChocosGot.bind this
        @setTShirts = @setTShirts.bind this
        @showSubmitsOnDay = @showSubmitsOnDay.bind this
        @state =
            day: null

    setChocosGot: (index, count) ->
        () =>
            chocosGot = (0 for c in @props.user.chocos)
            # support chocosGot == []
            for c, i in @props.user.chocosGot
                chocosGot[i] = c
            chocosGot[index] = count
            await callApi "user/#{@props.user._id}/setChocosGot", {chocosGot}
            @props.handleReload()

    setTShirts: (count) ->
        () =>
            await callApi "user/#{@props.user._id}/setTShirtsGot", {TShirts: count}
            @props.handleReload()

    showSubmitsOnDay: (day) ->
        @setState {day}

    hideSubmitsOnDay: () =>
        @setState {day: null}

    render: () ->
        <div>
            {`<UserBadge {...this.props} onTShirtsClick={this.setTShirts}/>`}
            {GROUPS[@props.user.userList]?.chocos && <Chocos chocos={@props.user.chocos} chocosGot={@props.user.chocosGot} onClick={@setChocosGot}/> }
            <SolvedByWeek users={[@props.user]} userList={@props.user.userList} details={false} headerClass="h2"/>
            {if @props.calendar then <ContributeByWeekCalendar calendar={@props.calendar} clickOnDay={@showSubmitsOnDay}/>}
            {if @state.day
                <>
                    <div><Button onClick={@hideSubmitsOnDay} bsSize="xsmall">{LangRaw("hide_submits", @props.lang)}</Button></div>
                    <SubmitsOnDayConnected day={@state.day} userId={@props.user._id}/>
                </>
            }
            <h2>{LangRaw("results", @props.lang)}</h2>
            {
            res = []
            a =  (el) -> res.push(el)
            for result in @props.results
                data =
                    user: @props.user
                    results: result
                a <Table data={[data]} details={false} me={@props.me} headerText={false} key={result[0]._id}/>
            res}
        </div>

export default withLang FullUser