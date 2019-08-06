React = require('react')

import globalStyles from './global.css'

import userTableHeader from './UserTableHeader'

import withTheme from '../lib/withTheme'

import {startDayForWeeks, MSEC_IN_WEEK} from '../../server/calculations/ratingConstants'

weekSet = (userList) ->
    thisStart = new Date(startDayForWeeks["" + userList])
    now = new Date()
    nowWeek = Math.floor((now - thisStart) / MSEC_IN_WEEK)
    [0..nowWeek]

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

weekHeader = (weekNumber, userList) ->
    thisStart = new Date(startDayForWeeks[userList])
    startDay = new Date(+thisStart + MSEC_IN_WEEK * weekNumber)
    endDay = new Date(+startDay + MSEC_IN_WEEK - 1)
    startDay.getUTCDate() + "-" + endDay.getUTCDate() + "." + (endDay.getUTCMonth()+1)

Header = (props) ->
    cl = props.headerClass || "h1"
    H = React.createElement(cl, {}, 'Сданные задачи по неделям');
    <div>
        {H}
        <p className="small">
            Количество зачтенных посылок за неделю; 0.5, если посылки были, но ни одной зачтенной
        </p>
    </div>


SolvedByWeekRow = (props) ->
    <tr>
        <td className={globalStyles.border} />
        {
        res = []
        a = (el) -> res.push(el)
        userTableHeader(res, props)
        a <td className={globalStyles.border} key="border"/>
        data = props.user.byWeek
        for w in props.weeks
            if props.header
                a <td className={globalStyles.mainTable_td} key={w}>
                    {weekHeader(w, props.userList)}
                </td>
            else
                text = ""
                if data?.solved and w of data.solved
                    text = data.solved[w]
                    if props.theme == "light"
                        style = backgroundColor: bgColor(data.solved[w])
                    else  
                        style = backgroundColor: bgColorDark(data.solved[w])
                else
                    text = "0"
                    style =
                        bgColor: bgColor(undefined)
                if data?.ok and w of data.ok
                    text += " + " + data.ok[w]
                a <td className={globalStyles.mainTable_td} key={w} style={style}>
                    {text}
                </td>
        res
        }
        <td className={globalStyles.border} />
    </tr>

SolvedByWeekRowWithTheme = withTheme(SolvedByWeekRow)

export default SolvedByWeek = (props) ->
    if not props.users?.length
        return <table className={globalStyles.mainTable}/>
    weeks = weekSet(props.userList)

    <div>
        <Header headerClass={props.headerClass} />
        <table className={globalStyles.mainTable}>
            <tbody>
                {
                res = []
                a = (el) -> res.push(el)
                a <SolvedByWeekRowWithTheme header={true} details={props.details} user={props.users[0]} userList={props.userList} weeks={weeks} key={"header"}/>
                for user in props.users
                    a <SolvedByWeekRowWithTheme details={props.details} user={user} weeks={weeks} key={user._id}/>
                res}
            </tbody>
        </table>
    </div>