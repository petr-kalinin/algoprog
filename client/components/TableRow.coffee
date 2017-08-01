React = require('react')

import styles from './TableRow.css'
import globalStyles from './global.css'

import UserName from './UserName'
import CfStatus from './CfStatus'

data = 
    details: true
    user:
        _id: "123456",
        name: "Василий Пупкин"
        level:
            current: "1А"
        rating: 123
        activity: 23.456
        cf:
            login: "abc"
            rating: 456
            color: "red"
            activity: 20
            progress: 100
    tables: [{
        _id: "1А",
        tables: [{
            _id: "1А: фыв",
            results: [{
                _id: "123",
                table: "p123",
                problemName: "Задача 1",
                solved: 1,
                ok: 0,
                ignored: 0,
                attempts: 1,
                total: 1
            }, {
                _id: "456"
                table: "p456",
                problemName: "Задача 2"
                solved: 0,
                ok: 1,
                ignored: 0,
                attempts: 2
                total: 1
            }]
        }, {
            _id: "1А: ячс",
            results: [{
                _id: "789"
                table: "p789",
                problemName: "Задача 3"
                solved: 0,
                ok: 0,
                ignored: 1,
                attempts: 3
                total: 1
            }]
        }], 
    }, {
        _id: "1Б",
        tables: [{
            _id: "1Б: йцу",
            results: [{
                _id: "1"
                table: "p1",
                problemName: "Задача 4"
                solved: 0,
                ok: 0,
                ignored: 0,
                attempts: 4
                total: 1
            }]
        }, {
            _id: "1Б: фыв",
            results: [{
                _id: "2"
                table: "p2",
                problemName: "Задача 5"
                solved: 0,
                ok: 0,
                ignored: -10,
                attempts: 0
                total: 1
            }, {
                _id: "3"
                table: "p3",
                problemName: "Задача 6"
                solved: 1,
                ok: 0,
                ignored: 0,
                attempts: 0
                total: 1
            }]
        }]
    }]
        
        
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


    <td title={props.user.name + " : " + props.result.problemName} className={className + " " + styles.res + " " + globalStyles.mainTable_td}onDoubleClick={dbClickHandler}>
        {text}
    </td>
            
TotalResult = (props) ->
    return 
        <td className={globalStyles.mainTable_td}>
            {props.total.solved} 
            {if props.total.ok then " + " + props.total.ok}
            {" / " + props.total.total}
        </td>

Attempts = (props) ->
    return <td className={globalStyles.mainTable_td}>{props.total.attempts}</td>

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

export default TableRow = (p) ->
    props = data
    total = null
    return
        <tr>
            <td className={globalStyles.border} />
            <td className={globalStyles.mainTable_td}>
                <UserName user={props.user} />
            </td>
            {
            if props.details
                res = []
                a = (el) -> res.push(el)
                a <td className={globalStyles.mainTable_td} key="level">{props.user.level?.current}</td>
                a <td className={globalStyles.mainTable_td} key="rating">{props.user.rating}</td>
                a <td className={globalStyles.mainTable_td} key="activity">{props.user.activity.toFixed(1)}</td>
                a <td className={globalStyles.mainTable_td} key="cf"><CfStatus cf={props.user.cf}/></td>
                res}
            {
            res = []
            a = (el) -> res.push(el)
            for table in props.tables
                subTotal = null
                for subtable in table.tables
                    a <td className={globalStyles.border} key={subtable._id + "b"}/>
                    for result in subtable.results
                        a <Result result={result} user={props.user} key={result._id}/> 
                        subTotal = addTotal(subTotal, result)
                a <td className={globalStyles.border} key={table._id + "b"} />
                a <TotalResult total={subTotal} key={table._id + "t"} />
                total = addTotal(total, subTotal)
            res}
            <td className={globalStyles.border} />
            <TotalResult total={total}/>
            <Attempts total={total}/>
            <td className={globalStyles.border} />
        </tr>
