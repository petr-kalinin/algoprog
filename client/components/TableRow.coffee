React = require('react')

import styles from './TableRow.css'
import globalStyles from './global.css'

import UserName from './UserName'
import CfStatus from './CfStatus'

Result = (props) ->
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
        
    realProblem = r.table.substr(1)
    runId = r.lastSubmitId
    runSuff = ''
    if runId
        if runId.indexOf("p") > 0
            runId = runId.substr(0, runId.indexOf("p"))  # strip problem suffix
        runSuff = '&run_id=' + runId
    dbClickUrl = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=' + realProblem + runSuff

    ctrlDbClickUrl = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=' + realProblem + '&submit&user_id=' + props.user._id
    
    dbClickHandler = (event) ->
        if event.ctrlKey 
            window.open(ctrlDbClickUrl, '_blank') 
        else 
            window.open(dbClickUrl, '_blank')


    <td title={props.user.name + " : " + props.result.problemName} className={className + " " + styles.res + " " + globalStyles.mainTable_td} onDoubleClick={dbClickHandler}>
        {text}
    </td>
        
            
TotalResult = (props) ->
    return 
        <td className={globalStyles.mainTable_td}>
            {if props.header
                "="
            else
                ("" + props.total.solved + 
                 (if props.total.ok then " + " + props.total.ok else "") +
                " / " + props.total.total)
            }
        </td>

Attempts = (props) ->
    return <td className={globalStyles.mainTable_td}>
        {if props.header then "Попыток" else props.total.attempts}
    </td>

accountAttempts = (result) ->
    if result.solved or result.ok
        result.attempts
    else
        0

addTotal = (a, b) ->
    if not a
        return b
    else if not b
        return a
    return
        solved: a.solved + b.solved
        ok: a.ok + b.ok
        ignored: a.ignored + b.ignored
        attempts: accountAttempts(a) + accountAttempts(b)
        total: a.total + b.total

export default TableRow = (props) ->
    total = null
    h = props.header
    return
        <tr>
            <td className={globalStyles.border} />
            <td className={globalStyles.mainTable_td}>
                {if h then "" else <UserName user={props.user} />}
            </td>
            {
            res = []
            a = (el) -> res.push(el)
            if props.details
                a <td className={globalStyles.mainTable_td} key="level" title="Уровень">
                    {if h then "У" else props.user.level?.current}
                </td>
                a <td className={globalStyles.mainTable_td} key="rating" title="Рейтинг">
                    {if h then "Р" else props.user.rating}
                </td>
                a <td className={globalStyles.mainTable_td} key="activity" title="Активность">
                    {if h then "А" else props.user.activity.toFixed(1)}
                </td>
                a <td className={globalStyles.mainTable_td} key="cf" title="Codeforces">
                    {if h then "CF" else <CfStatus cf={props.user.cf}/>}
                </td>
            for table in props.tables
                subTotal = null
                for subtable in table.tables
                    a <td className={globalStyles.border} key={subtable._id + "b"}/>
                    if props.header
                        a <td className={globalStyles.mainTable_td} colSpan={subtable.colspan}  key={subtable._id + "c"}>
                            {subtable.name}
                        </td>
                    else
                        for result in subtable.results
                            a <Result header={props.header} result={result} user={props.user} key={result._id}/> 
                            subTotal = addTotal(subTotal, result)
                a <td className={globalStyles.border} key={table._id + "b"} />
                a <TotalResult header={props.header} total={subTotal} key={table._id + "t"} />
                total = addTotal(total, subTotal)
            res}
            <td className={globalStyles.border} />
            <TotalResult header={props.header} total={total}/>
            <Attempts header={props.header} total={total}/>
            <td className={globalStyles.border} />
        </tr>
