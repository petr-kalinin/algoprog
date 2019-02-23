React = require('react')

import styles from './TableRow.css'
import globalStyles from './global.css'

import userTableHeader from './UserTableHeader'

import addTotal from '../lib/addTotal'

ProblemResult = (props) ->
    r = props.result
    text1 = r.points
    text2 = undefined
    if r.attempts > 0
        text2 = "(x#{r.attempts})"
    text3 = undefined
    if r.points != props.resultLate.points
        text3 = <div className="small"  title="После дедлайна">[{props.resultLate.points}]</div>

    className =
        if r.solved > 0
            "ac"
        else if r.ignored > 0
            "ig"
        else if r.ok > 0
            "ok"
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
        {text1}
        {if text2 then <br/>}
        {text2 || ""}
        {if text3 then <br/>}
        {text3 || ""}
    </td>

totalResultClass = (result) ->
    if not result
        return undefined
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
        if props.result?.problemName
            title = props.user.name + ": " + props.result.problemName
    return <td className={style} title={title}>
            {if props.header
                "="
            else
                props.result?.points
            }
            {if not props.header and props.result?.points != props.resultLate?.points
                <div className="small" title="После дедлайна">[{props.resultLate?.points}]</div>
            }
        </td>

Result = (props) ->
    if props.result.total > 1
        `<TotalResult {...props}/>`
    else
        `<ProblemResult {...props}/>`

Attempts = (props) ->
    return <td className={globalStyles.mainTable_td}>
        {if props.header then "Попыток" else props.result.attempts}
    </td>

export default TableRow = (props) ->
    total = undefined
    totalLate = undefined
    h = props.header
    return <tr>
            <td className={globalStyles.border} />
            {
            res = []
            a = (el) -> res.push(el)
            userTableHeader(res, props)
            for table in props.results
                subTotal = null
                subTotalLate = null
                for subtable in table.results
                    a <td className={globalStyles.border} key={subtable._id + "b"}/>
                    if props.header
                        a <td className={globalStyles.mainTable_td} colSpan={subtable.colspan}  key={subtable._id + "c"}>
                            {subtable.name}
                        </td>
                    else
                        for i in [0...subtable.results.length]
                            result = subtable.results[i]
                            resultLate = subtable.resultsLate[i]
                            a <Result header={props.header} result={result} resultLate={resultLate} user={props.user} key={result._id + "::" + subtable._id}/>
                            subTotal = addTotal(subTotal, result)
                            subTotalLate = addTotal(subTotalLate, resultLate)
                a <td className={globalStyles.border} key={table._id + "b"} />
                if props.results.length > 1
                    a <TotalResult header={props.header} result={subTotal} resultLate={subTotalLate} key={table._id + "t"} />
                total = addTotal(total, subTotal)
                totalLate = addTotal(totalLate, subTotalLate)
            res}
            <td className={globalStyles.border} />
            <TotalResult header={props.header} result={total} resultLate={totalLate}/>
            <td className={globalStyles.border} />
        </tr>
