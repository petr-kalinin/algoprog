React = require('react')

import globalStyles from './global.css'
import styles from './SolvedByWeek.css'

import userTableHeader from './UserTableHeader'

import withTheme from '../lib/withTheme'

import {startDayForWeeks, lastWeeksToShow, MSEC_IN_WEEK} from '../../server/calculations/ratingConstants'

weekSet = (userList) ->
    thisStart = new Date(startDayForWeeks["" + userList])
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
    thisStart = new Date(startDayForWeeks[userList])
    endDay = new Date(+thisStart + MSEC_IN_WEEK * (weekNumber + 1) - 1)
    startDay = new Date(+endDay - MSEC_IN_WEEK * weekCount + 1)
    endDay.getUTCDate() + "." + (endDay.getUTCMonth()+1) + "-" + startDay.getUTCDate() + "." + (startDay.getUTCMonth()+1)

Header = (props) ->
    cl = props.headerClass || "h1"
    H = React.createElement(cl, {}, 'Сданные задачи по неделям');
    <div>
        {H}
        <p className="small">
            Количество зачтенных посылок за неделю; 0.5, если посылки были, но ни одной зачтенной
        </p>
        <p className="small">
            <b>Таблица развернута: ось времени направлена влево, недавние недели находятся слева.</b>
        </p>
    </div>


SolvedByWeekRow = (props) ->
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

class SolvedByWeek extends React.PureComponent
  render: () ->
    if not @props.users?.length
        return <table className={globalStyles.mainTable}/>
    weeks = weekSet(@props.userList)

    <div>
        <Header headerClass={@props.headerClass} />
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

export default SolvedByWeek