React = require('react')
deepcopy = require("deepcopy")

import UserBadge from './UserBadge'
import SolvedByWeek from './SolvedByWeek'

export default User = (props) ->
    <div>
        {`<UserBadge {...props}/>`}
        <SolvedByWeek users={[props.user]} userList={props.user.userList} details={false}/>
    </div>
