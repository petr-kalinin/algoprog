React = require('react')
FontAwesome = require('react-fontawesome')

import Problem from './Problem'
import Level from './Level'
import Contest from './Contest'

Page = (props) ->
    <div dangerouslySetInnerHTML={{__html: props.material.content}}>
    </div>

MaterialProper = (props) ->
    if props.material.error
        return if props.material.error == 'level'
            <h1><FontAwesome name="ban"/> У вас нет прав на просмотр этого материала</h1>
        else
            <h1><FontAwesome name="ban"/>Неизвестная ошибка</h1>
    if props.material?.type == 'page'
        `<Page {...props} />`
    else if props.material?.type == 'level'
        `<Level {...props} />`
    else if props.material?.type == 'simpleLevel'
        `<Level {...props} simple={true}/>`
    else if props.material?.type == 'contest'
        `<Contest {...props} />`
    else if props.material?.type == 'epigraph'
        `<Page {...props} />`
    else if props.material?.type == 'problem'
        `<Problem {...props} />`
    else if props.material?.type == 'topic'
        `<Level {...props}/>`
    else
        <div>Unknown material type</div>

export default Material = (props) ->
    <div>
        <MaterialProper material={props.material} handleReload={props.handleReload}/>
    </div>
