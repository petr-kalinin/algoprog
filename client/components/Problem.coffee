React = require('react')

import getTestSystem from '../testSystems/TestSystemRegistry'

import SubmitList from './SubmitList'
import EditablePage from './EditablePage'

problemId = (props) ->
    props.material._id.substring(1)

export default Problem = (props) ->
    if props.material.blocked
        return <div>Blocked</div>
    testSystem = getTestSystem(props.material.testSystemData.system)
    <div>
        <EditablePage material={props.material} reloadMaterial={props.handleReload}/>
        {testSystem.problemLink(props.material)}
        {`<SubmitList {...props}/>`}
    </div>
