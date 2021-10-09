React = require('react')

import getContestSystem from '../contestSystems/ContestSystemRegistry'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

import {ContestInfo} from './Contest'
import globalStyles from './global.css'
import styles from './Monitor.css'
import userTableHeader from './UserTableHeader'

Row = (props) ->
    h = props.header
    contestSystem = getContestSystem(props.contest.contestSystemData.system)
    ProblemResult = contestSystem.ProblemResult()
    TotalResult = contestSystem.TotalResult()
    UserAddInfo = contestSystem.UserAddInfo()
    <tr>
        <td className={globalStyles.border} />
        {
        res = []
        a = (el) -> res.push(el)
        userTableHeader(res, props)
        a <td className={globalStyles.border} key="start"/>
        if UserAddInfo
            a <UserAddInfo header={props.header} contest={props.contest} user={props.user} contestResult={props.result} key="addinfo"/>
            a <td className={globalStyles.border} key="addinfo_border"/>
        for problem, i in props.contest.problems
            a <ProblemResult header={props.header} problemIndex={i} contest={props.contest} user={props.user} problem={problem} result={props.result?.problemResults[problem._id]} key={problem._id + "t"} />
        res}
        <td className={globalStyles.border} />
        <TotalResult {props...}/>
        <td className={globalStyles.border} />
    </tr>

Table = (props) ->
    <div>
        <h1>{props.contest.name}: Результаты</h1>
        <ContestInfo {props...}/>
        <div className={globalStyles.mainTable_div}>
            <table className={globalStyles.mainTable}>
                <tbody>
                    <Row header={true} contest={props.contest} key="header"/>
                    {
                    res = []
                    a = (el) -> res.push(el)
                    for result in props.monitor
                        a <Row user={result.fullUser} result={result} contest={props.contest} key={result.user._id}/>
                    res}
                </tbody>
            </table>
        </div>
    </div>

options =
    urls: (props) ->
        contestResult: "contestResult/#{props.contest._id}/#{props.myUser._id}"

export default withMyUser(ConnectedComponent(Table, options))