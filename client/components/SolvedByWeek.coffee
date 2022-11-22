React = require('react')
FontAwesome = require('react-fontawesome')

import Button from 'react-bootstrap/lib/Button'

import globalStyles from './global.css'
import styles from './SolvedByWeek.css'

import userTableHeader from './UserTableHeader'

import {LangRaw} from '../lang/lang'

import GROUPS from '../lib/groups'
import withLang from '../lib/withLang'
import withTheme from '../lib/withTheme'

import {lastWeeksToShow, MSEC_IN_WEEK} from '../../server/calculations/ratingConstants'

weekSet = (userList) ->
    thisStart = new Date(GROUPS["" + userList].startDayForWeeks)
    now = new Date()
    nowWeek = Math.floor((now - thisStart) / MSEC_IN_WEEK)
    res = [(nowWeek - lastWeeksToShow + 1)..nowWeek]
    res.reverse()

bgColor = (number) ->
    if !number
        "#ffffff"
    else if number<=2
        "#ddffdd"
    else if number<=5
        "#bbffbb"
    else if number<=8
        "#88ff88"
    else
        "#22ff22"

bgColorDark = (number) ->
    if !number
        "#ffffff"
    else if number<=2
        "#a2e8a2"
    else if number<=5
        "#8ce58c"
    else if number<=8
        "#47cc47"
    else
        "#1ee51e"

weekHeader = (weekNumber, weekCount, userList) ->
    thisStart = new Date(GROUPS[userList].startDayForWeeks)
    endDay = new Date(+thisStart + MSEC_IN_WEEK * (weekNumber + 1) - 1)
    startDay = new Date(+endDay - MSEC_IN_WEEK * weekCount + 1)
    endDay.getUTCDate() + "." + (endDay.getUTCMonth()+1) + "-" + startDay.getUTCDate() + "." + (startDay.getUTCMonth()+1)

Header = withLang (props) ->
    toggleFullscreen = props.toggleFullscreen
    fullscreenElement = <Button onClick={toggleFullscreen}><FontAwesome name={"arrows-alt"} /></Button>
    cl = props.headerClass || "h1"
    H = React.createElement(cl, {}, [LangRaw("solved_problems_by_week", props.lang) + " ", fullscreenElement])
    <div>
        {H}
        {LangRaw("solved_by_week_notes", props.lang)}
    </div>


SolvedByWeekRow = withLang (props) ->
    <tr>
        <td className={globalStyles.border} />
        {
        res = []
        a = (el) -> res.push(el)
        userTableHeader(res, props)
        if res.length
            a <td className={globalStyles.border} key="border"/>
        data = props.user.byWeek
        for w, i in props.weeks
            if props.header
              if i % 3 == 0
                weekCount = if props.weeks.length - i > 2 then 3 else props.weeks.length - i
                a <td className={globalStyles.mainTable_td} key={w} colSpan={weekCount}>
                    {weekHeader(w, weekCount, props.userList)}
                </td>
            else
                text = ""
                if data?.solved and w of data.solved
                    text = data.solved[w]
                    if props.theme == "dark"
                        style = backgroundColor: bgColorDark(data.solved[w])
                    else
                        style = backgroundColor: bgColor(data.solved[w])
                else
                    text = "0"
                    style =
                        bgColor: bgColor(undefined)
                textAdd = undefined
                if data?.ok and w of data.ok
                    textAdd = <span className={styles.textAdd}>{" + " + data.ok[w]}</span>
                a <td className={globalStyles.mainTable_td} key={w} style={style}>
                    {text}{textAdd}
                </td>
        res
        }
        <td className={globalStyles.border} />
    </tr>

SolvedByWeekRowWithTheme = withTheme(SolvedByWeekRow)

class SolvedByWeek extends React.Component
    constructor: (props) ->
        super(props)
        @toggleFullscreen = @toggleFullscreen.bind this

    toggleFullscreen: () ->
        (e) ->
            el = document.getElementById("solvedByWeek")
            rfs = el.requestFullScreen or el.webkitRequestFullScreen or el.mozRequestFullScreen or el.msRequestFullscreen
            rfs.call(el)

    render: () ->
        if not @props.users?.length
            return <table className={globalStyles.mainTable}/>
        weeks = weekSet(@props.userList)
        cls = if @props.theme == "dark" then styles.solvedByWeekDark else styles.solvedByWeek
        <div id="solvedByWeek" className={cls}>
            <Header headerClass={@props.headerClass} toggleFullscreen={@toggleFullscreen()}/>
            <div className={globalStyles.mainTable_div} ref={(d) => if d then @table_div = d }>
            <table className={globalStyles.mainTable}>
                <tbody>
                    {
                    res = []
                    a = (el) -> res.push(el)
                    a <SolvedByWeekRowWithTheme header={true} details={@props.details} user={@props.users[0]} userList={@props.userList} weeks={weeks} key={"header"}/>
                    for user in @props.users
                        a <SolvedByWeekRowWithTheme details={@props.details} user={user} weeks={weeks} key={user._id}/>
                    res}
                </tbody>
            </table>
            </div>
        </div>

export default withTheme(SolvedByWeek)