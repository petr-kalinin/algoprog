React = require('react')
moment = require('moment')
FontAwesome = require('react-fontawesome')

import Table from 'react-bootstrap/lib/Table'

import ShadowedSwitch from './ShadowedSwitch'

import outcomeToText from '../lib/outcomeToText'

import styles from './SubmitListTable.css'

LANGUAGE_ABBREVIATED = 
    "Python 3" : "Py3"
    "Free Pascal 3" : "FreePas"
    "PascalABC 3" : "PasABC"
    "GNU C++" : "C++"
    "GNU C" : "C"
    "Borland Delphi" : "Delphi"
    "Java JDK" : "Java"
    "PHP": "PHP"
    "Python 2" : "Py2"
    "Perl" : "Perl"
    "Mono C#" : "C#"
    "Ruby" : "Ruby"
    "Haskell GHC" : "Haskell"
    "FreeBASIC" : "FreeBASIC"
    "GNU C++ / sanitizer" : "C++/sanitizer"


maxVal = (submit, field) ->
    res = -1
    for index, result of (submit.results?.tests || []) 
        val = +result[field]
        if val > res
            res = val
    return if res < 0 then undefined else res

export default SubmitListTable = (props) ->
    <div className={styles.outerDiv}>
        <Table responsive striped condensed hover>
            <thead>
                <tr>
                    <th>Время попытки</th>
                    <th>Результат</th>
                    <th>Язык</th>
                    <th><span title="(сек)">Время</span></th>
                    <th><span title="ОЗУ (МБ)">Память</span></th>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                    {if props.handleDiffClick
                        <th>&nbsp;</th>
                    }
                 </tr>
            </thead>
            <tbody>
                {props.submits?.map?((submit) =>
                    [cl, message] = outcomeToText(submit.outcome)
                    if submit._id == props.activeId
                        cl += " " + styles.active
                    time = maxVal(submit, "time")
                    mem = (maxVal(submit, "max_memory_used")) / (1024*1024)
                    mem = mem.toFixed(2)
                    <tr key={submit._id} className={cl} onClick={props.handleSubmitClick(submit)} style={cursor: "hand"}>
                        <td>{moment(submit.time).format('DD.MM.YY HH:mm:ss')}</td>
                        <td>{message}</td>
                        <td>
                            <div className='visible-xs visible-sm'>{LANGUAGE_ABBREVIATED[submit.language]}</div>
                            <div className='hidden-xs hidden-sm'>{submit.language}</div>
                        </td>
                        <td><span title="(сек)">{if time? then time / 1000 else ""}</span></td>
                        <td><span title="ОЗУ (МБ)">{if mem >= 0 then mem else ""}</span></td>
                        <td>{submit.comments?.length && <span title="Есть комментарии"><FontAwesome name="comment"/></span> || ""}</td>
                        <td><span title="Подробнее"><a onClick={props.handleSubmitClick(submit)} href="#"><FontAwesome name="eye"/></a></span></td>
                        {if props.handleDiffClick
                            <td>
                                <span onClick={props.handleDiffClick(0, submit)} href="#">
                                    <ShadowedSwitch on={props.activeDiffId[0] == submit._id}>
                                        <FontAwesome name="plus"/>
                                    </ShadowedSwitch>
                                </span>
                                <span onClick={props.handleDiffClick(1, submit)} href="#">
                                    <ShadowedSwitch on={props.activeDiffId[1] == submit._id}>
                                        <FontAwesome name="minus"/>
                                    </ShadowedSwitch>
                                </span>
                            </td>
                        }
                    </tr>
                ).reverse()}
            </tbody>
        </Table>
        {
        if props.admin and props.submits?[0] 
            infProblem = props.submits[0].problem.substr(1)
            <a href={"https://informatics.msk.ru/moodle/mod/statements/view3.php?" + "chapterid=#{infProblem}&submit&user_id=#{props.submits[0].user}"} target="_blank">Попытки на информатикс</a>
        }
    </div>
