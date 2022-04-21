React = require('react')
deepcopy = require('deepcopy')

import getTestSystem from '../testSystems/TestSystemRegistry'

import SubmitList from './SubmitList'
import EditablePage from './EditablePage'

problemId = (props) ->
    props.material._id.substring(1)

stripLabel = (material) ->
    idx = material._id.indexOf("!")
    if idx != -1
        material = deepcopy(material)
        material._id = material._id.substring(0, idx)
    return material

export default Problem = (props) ->
    testSystem = getTestSystem(props.material.testSystemData.system)
    <div>
        <EditablePage material={props.material} reloadMaterial={props.handleReload}/>
        {
            materialStripped = stripLabel(props.material)
            testSystem.problemLink(materialStripped)
            `<SubmitList {...props} material={materialStripped}/>`
        }
    </div>
