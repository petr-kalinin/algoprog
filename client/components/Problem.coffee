React = require('react')

import getTestSystem from '../testSystems/TestSystemRegistry'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

import ContestHeader from './ContestHeader'
import SubmitList from './SubmitList'
import EditablePage from './EditablePage'

problemId = (props) ->
    props.material._id.substring(1)

Problem = (props) ->
    if props.material.blocked
        return <div>Blocked</div>
    testSystem = getTestSystem(props.material.testSystemData.system)
    <div>
        <ContestHeader {props...}/>
        <h1>{props.problem.letter}. {props.problem.name}</h1>
        <EditablePage material={props.material} reloadMaterial={props.handleReload}/>
        {props.contest.hasStatements && <p><a href={"/api/contestStatements/#{props.contest._id}"}>Условия в pdf</a></p>}
        {testSystem.problemLink(props.material)}
        {`<SubmitList {...props}/>`}
    </div>

options =
    urls: (props) ->
        contestResult: "contestResult/#{props.contest._id}/#{props.myUser._id}"
        contest: "contest/#{props.contest._id}"
        problem: "problem/#{props.contest._id}/#{props.problem._id}"

export default withMyUser(ConnectedComponent(Problem, options))