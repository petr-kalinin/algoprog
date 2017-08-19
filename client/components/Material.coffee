React = require('react')
import { Link } from 'react-router-dom'

export default Material = (props) ->
    <div dangerouslySetInnerHTML={{__html: props.material.content}}>
    </div>
