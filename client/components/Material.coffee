React = require('react')

import Problem from './Problem'
import Level from './Level'
import Contest from './Contest'

Page = (props) ->
    <div dangerouslySetInnerHTML={{__html: props.material.content}}>
    </div>

MaterialProper = (props) ->
    if props.material?.type == 'page'
        `<Page {...props} />`
    else if props.material?.type == 'level'
        `<Level {...props} />`
    else if props.material?.type == 'contest'
        `<Contest {...props} />`
    else if props.material?.type == 'epigraph'
        `<Page {...props} />`
    else if props.material?.type == 'problem'
        `<Problem {...props} />`
    else
        <div>Unknown material type</div>

export default Material = (props) ->
    <div>
        <MaterialProper material={props.material} />
    </div>
