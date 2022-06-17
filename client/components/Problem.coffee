React = require('react')
deepcopy = require('deepcopy')

import getTestSystem from '../testSystems/TestSystemRegistry'

import withLang from '../lib/withLang'

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

export default Problem = withLang (props) ->
    testSystem = getTestSystem(props.material.testSystemData.system)
    materialStripped = stripLabel(props.material)
    <div>
        <EditablePage material={props.material} reloadMaterial={props.handleReload}/>
        {testSystem.problemLink(materialStripped, props.lang)}
        {`<SubmitList {...props} material={materialStripped}/>`}
    </div>
