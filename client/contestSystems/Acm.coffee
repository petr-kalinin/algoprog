React = require('react')

import ProblemList from '../components/ProblemList'
import globalStyles from '../components/global.css'
import withTheme from '../lib/withTheme'

import styles from '../components/Monitor.css'

problemBadgeImpl = (result) ->
    if not result
        return badge
    badge = ""
    if result.contestResult.ok > 0
        badge = "+"
    else if result.attempts > 0
        badge = "-"
    if result.attempts > 0
        badge += result.attempts
    if result.ps > 0
        text = "?" + text
    badge


Result = (props) ->
    r = props.result
    text = problemBadgeImpl(r)

    className =
        if not r
            ""
        else if r.contestResult.ok > 0
            if props.theme == "dark"
                "darkac"
            else 
                "ac"
        else if r.attempts > 0
            "wa"
        else
            undefined

    if className
        className = globalStyles[className]

    dbClickUrl = "/problem/#{props.contest._id}/#{props.problem._id}"
    ctrlDbClickUrl = "/reviewResult/#{props.user?._id}::#{props.problem._id}::#{props.contest._id}"

    dbClickHandler = (event) ->
        if event.ctrlKey
            window.goto(ctrlDbClickUrl)()
        else
            window.goto(dbClickUrl)()

    username = props.user?.name || props.user
    <td title={username + " : " + props.problem.name} className={className + " " + styles.res + " " + globalStyles.mainTable_td} onDoubleClick={dbClickHandler}>
        {text}<br/>{r?.contestResult.time || ""}
    </td>

Result = withTheme(Result)

ProblemResult = (props) ->
    if props.header
        <td className={styles.res + " " + globalStyles.mainTable_td}>{props.problemIndex + 1}</td>
    else
        <Result {props...}/>

Time = (props) ->
    return <td className={globalStyles.mainTable_td}>
        {if props.header then "Время" else props.result.contestResult.time}
    </td>

Total = (props) ->
    return <td className={globalStyles.mainTable_td}>
        {if props.header then "=" else props.result.contestResult.ok}
    </td>

TotalResult = (props) ->
    [
        <Total {props...}/>
        <Time {props...}/>
    ]

export default class Archive
    problemBadge: problemBadgeImpl

    problemStyle: (result) ->
        switch
            when result.contestResult.ok > 0 then "success"
            when result.attempts > 0 then "danger"
            else undefined

    Contest: () ->
        ProblemList

    ProblemResult: () ->
        ProblemResult

    TotalResult: () ->
        TotalResult

    UserAddInfo: () ->
        (props) ->
            null