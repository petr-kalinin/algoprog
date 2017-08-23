React = require('react')
import { Link } from 'react-router-dom'

import Problem from './Problem'

Page = (props) ->
    <div dangerouslySetInnerHTML={{__html: props.material.content}}>
    </div>

export default Material = (props) ->
    if props.type == 'page'
        `<Page {...props} />`
    else
        `<Problem {...props} />`
