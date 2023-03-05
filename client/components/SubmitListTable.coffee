React = require('react')
moment = require('moment')
FontAwesome = require('react-fontawesome')

import Table from 'react-bootstrap/lib/Table'
import { Link } from 'react-router-dom'

import {LangRaw} from '../lang/lang'

import outcomeToText from '../lib/outcomeToText'
import withLang from '../lib/withLang'
import getTestSystem from '../testSystems/TestSystemRegistry'

import ShadowedSwitch from './ShadowedSwitch'

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

export default SubmitListTable = withLang (props) ->
    wasNotSimilar = false
    wasSimilar = false
    LANG = (id) -> LangRaw(id, props.lang)
    <div className={styles.outerDiv}>
        <Table responsive striped condensed hover>
            <thead>
                <tr>
                    {if props.showProblems
                        <>
                          <th>{LANG("level")}</th>
                          <th>{LANG("problem")}</th>
                        </>
                    }
                    <th>{LANG("attempt_time")}</th>
                    <th>{LANG("result")}</th>
                    <th>{LANG("language")}</th>
                    {if not props.showProblems
                        <>
                            <th><span title={LANG("in_seconds")}>{LANG("time")}</span></th>
                            <th><span title={LANG("in_mb")}>{LANG("memory")}</span></th>
                            <th>&nbsp;</th>
                            <th>&nbsp;</th>
                        </>
                    }
                    {if props.handleDiffClick
                        <th>&nbsp;</th>
                    }
                 </tr>
            </thead>
            <tbody>
                {props.submits?.map?((submit) =>
                    [cl, message] = outcomeToText(submit.outcome, props.lang)
                    if submit._id == props.activeId
                        cl += " " + styles.active
                    if not props.showProblems
                        time = maxVal(submit, "time")
                        mem = (maxVal(submit, "max_memory_used")) / (1024*1024)
                        mem = mem.toFixed(2)
                    res = []
                    res.push <tr key={submit._id} className={cl} onClick={if not props.showProblems then props.handleSubmitClick(submit)} style={cursor: if not props.showProblems then "hand"}>
                        {
                          if props.showProblems
                              <>
                                <td>{submit.fullProblem.level}</td>
                                <td><Link to="/material/#{submit.problem}">{submit.fullProblem.name}</Link></td>
                              </>
                        }
                        <td>{if submit.time=="_orig" then LANG("original_submit") else moment(submit.time).format('DD.MM.YY HH:mm:ss')}</td>
                        <td>{message}</td>
                        <td>
                            <div className='visible-xs visible-sm'>{LANGUAGE_ABBREVIATED[submit.language] || submit.language}</div>
                            <div className='hidden-xs hidden-sm'>{submit.language}</div>
                        </td>
                        {if not props.showProblems
                            <>
                              <td><span title={LANG("in_seconds")}>{if time? then time / 1000 else ""}</span></td>
                              <td><span title={LANG("in_mb")}>{if mem >= 0 then mem else ""}</span></td>
                              <td>{submit.comments?.length && <span title={LANG("has_comments")}><FontAwesome name="comment"/></span> || ""}</td>
                              <td><span title={LANG("details")}><a onClick={props.handleSubmitClick(submit)} href="#"><FontAwesome name="eye"/></a></span></td>
                            </>
                        }
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
                    if submit.similar
                        wasSimilar = true
                    if not wasNotSimilar and wasSimilar and not submit.similar
                        wasNotSimilar = true
                        res.push <tr key="similarHeader">
                            <td colSpan={if props.handleDiffClick then 8 else 7}>
                                <b>Похожие сабмиты</b>
                            </td>
                        </tr>
                    res
                ).reverse()}
            </tbody>
        </Table>
        {
        if props.admin and props.submits?[0] and not props.showProblems 
            s = props.submits[props.submits.length - 1]
            testSystem = getTestSystem(s.testSystemData?.system)
            testSystem.submitListLink(s, props.lang)
        }
    </div>
