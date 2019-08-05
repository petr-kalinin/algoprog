React = require('react')

import styles from './TableRow.css'
import globalStyles from './global.css'

import userTableHeader from './UserTableHeader'

import addTotal from '../lib/addTotal'

import { connect } from 'react-redux'

ProblemResult = (props) ->
    r = props.result
    text =
        if r.ignored < 0  # DQ
            ""
        else if r.solved > 0 or r.ok > 0
            "+" + (if r.attempts > 0 then r.attempts else "")
        else if r.attempts > 0
            "-" + r.attempts
        else
            " "
    if r.ps > 0
        text = "?" + text
        
    className =
        if r.solved > 0
            if props.theme == "light"
                "ac"
            else 
                "darkac"
        else if r.ignored > 0
            "ig"
        else if r.ok > 0
            if props.theme == "light"
                "ok"
            else 
                "darkok"
        else if r.ignored < 0
            "dq"
        else if r.attempts > 0
            "wa"
        else
            undefined

    if className
        className = globalStyles[className]

    dbClickUrl = "/material/#{r.table}"
    ctrlDbClickUrl = "/reviewResult/#{props.user._id}::#{r.table}"

    dbClickHandler = (event) ->
        if event.ctrlKey
            window.goto(ctrlDbClickUrl)()
        else
            window.goto(dbClickUrl)()


    <td title={props.user.name + " : " + props.result.problemName} className={className + " " + styles.res + " " + globalStyles.mainTable_td} onDoubleClick={dbClickHandler}>
        {text}
    </td>

totalResultClass = (result) ->
    if not result.problemName
        return undefined
    if result.total == result.solved
        return "full"
    else
        needed = result.required
        if result.problemName.slice(-1) == "В"
            needed = Math.ceil(needed / 2)
        else if result.problemName.slice(-1) == "Г"
            needed = Math.ceil(needed / 3)
        if result.solved >= needed
            return "done"
        else if result.solved > 0
            return "started"
        else
            return "none"

TotalResult = (props) ->
    style = globalStyles.mainTable_td
    title = ""
    if not props.header
        s = totalResultClass(props.result)
        if s
            style += " " + styles[s]
        if props.result.problemName
            title = props.user.name + ": " + props.result.problemName
    return <td className={style} title={title}>
            {if props.header
                "="
            else
                ("" + props.result.solved +
                 (if props.result.ok then " + " + props.result.ok else "") +
                " / " + props.result.required)
            }
        </td>

Result = (props) ->
    if props.result.total > 1
        `<TotalResult {...props}/>`
    else
        `<Theme {...props}/>`

Attempts = (props) ->
    return <td className={globalStyles.mainTable_td}>
        {if props.header then "Попыток" else props.result.attempts}
    </td>

export default TableRow = (props) ->
    total = undefined
    h = props.header
    return <tr>
            <td className={globalStyles.border} />
            {
            res = []
            a = (el) -> res.push(el)
            userTableHeader(res, props)
            for table in props.results
                subTotal = null
                for subtable in table.results
                    a <td className={globalStyles.border} key={subtable._id + "b"}/>
                    if props.header
                        a <td className={globalStyles.mainTable_td} colSpan={subtable.colspan}  key={subtable._id + "c"}>
                            {subtable.name}
                        </td>
                    else
                        for result in subtable.results
                            a <Result header={props.header} result={result} user={props.user} key={result._id + "::" + subtable._id}/>
                            subTotal = addTotal(subTotal, result)
                a <td className={globalStyles.border} key={table._id + "b"} />
                if props.results.length > 1
                    a <TotalResult header={props.header} result={subTotal} key={table._id + "t"} />
                total = addTotal(total, subTotal)
            res}
            <td className={globalStyles.border} />
            <TotalResult header={props.header} result={total}/>
            <Attempts header={props.header} result={total}/>
            <td className={globalStyles.border} />
        </tr>

mapStateToProps = (state) ->
    return
        theme: state.theme

Theme = connect(mapStateToProps)(ProblemResult)
