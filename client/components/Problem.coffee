React = require('react')
import { Link } from 'react-router-dom'

export default Problem = (props) ->
    <div dangerouslySetInnerHTML={{__html: props.material.content}}>
    </div>
