React = require('react')

import SubmitList from './SubmitList'
import SubmitForm from './SubmitForm'

problemId = (props) ->
    props.material._id.substring(1)

export default Problem = (props) ->
    href = "http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=" + problemId(props)
    <div>
        <div dangerouslySetInnerHTML={{__html: props.material.content}}>
        </div>
        <p><a href={href}>Задача на informatics</a></p>
        <SubmitForm problemId={problemId(props)}/>
        {`<SubmitList {...props}/>`}
    </div>
