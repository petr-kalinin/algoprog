React = require('react')
import { Link } from 'react-router-dom'

export default Problem = (props) ->
    href = "http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=" + props.material._id.substring(1)
    <div>
        <div dangerouslySetInnerHTML={{__html: props.material.content}}>
        </div>
        <a href={href}>Задача на informatics</a>
    </div>
