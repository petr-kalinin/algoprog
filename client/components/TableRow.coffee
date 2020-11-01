React = require('react')
FontAwesome = require('react-fontawesome')

import addTotal from '../lib/addTotal'
import withTheme from '../lib/withTheme'

import userTableHeader from './UserTableHeader'

import styles from './TableRow.css'
import globalStyles from './global.css'

SubFindMistakes = (props) ->
    if not props.subFindMistakes
        return null
    sfm = props.subFindMistakes
    res = []
    a = (el) -> res.push(el)
    for i in [0...sfm.none]
        a <FontAwesome name="star-o"/>
    for i in [0...sfm.wa]
        a <FontAwesome name="star-half-o"/>
    for i in [0...sfm.ok]
        a <FontAwesome name="star"/>
    title = "Поиск ошибок: #{sfm.none} не начаты, #{sfm.wa} неуспешны, #{sfm.ok} успешны"
    <div className={styles.subFindMistakes} title={title}>
        {res}
    </div>        

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
            if props.theme == "dark"
                "darkac"
            else 
                "ac"
        else if r.ignored > 0
            "ig"
        else if r.ok > 0
            if props.theme == "dark"
                "darkok"
            else 
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
        {text}
        <SubFindMistakes subFindMistakes={r.subFindMistakes}/>
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

ResultTheme = withTheme(ProblemResult)

Result = (props) ->
    if props.result.total > 1
        `<TotalResult {...props}/>`
    else
        `<ResultTheme {...props}/>`

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
                    if res.length
                        a <td className={globalStyles.border} key={subtable._id + "b"}/>
                    if props.header
                        a <td className={globalStyles.mainTable_td + " " + styles.subtableHeader} colSpan={subtable.colspan}  key={subtable._id + "c"}>
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
