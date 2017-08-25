React = require('react')
import { Link } from 'react-router-dom'

import Problem from './Problem'
import Level from './Level'
import Contest from './Contest'
import Tree from './Tree'

Page = (props) ->
    <div dangerouslySetInnerHTML={{__html: props.material.content}}>
    </div>

MaterialProper = (props) ->
    if props.material.type == 'page'
        `<Page {...props} />`
    else if props.material.type == 'level'
        `<Level {...props} />`
    else if props.material.type == 'contest'
        `<Contest {...props} />`
    else
        `<Problem {...props} />`

export default Material = (props) ->
    <div>
        <Tree tree={props.tree} id={props.material._id} />
        <MaterialProper material={props.material} />
    </div>
