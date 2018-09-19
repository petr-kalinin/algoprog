React = require('react')

import SubmitList from './SubmitList'
import EditablePage from './EditablePage'

problemId = (props) ->
    props.material._id.substring(1)

export default Problem = (props) ->
    <div>
        <EditablePage material={props.material} reloadMaterial={props.handleReload}/>
        {`<SubmitList {...props}/>`}
    </div>
