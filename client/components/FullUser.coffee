React = require('react')

import UserBadge from './UserBadge'
import SolvedByWeek from './SolvedByWeek'
import Table from './Table'

export default FullUser = (props) ->
    <div>
        {`<UserBadge {...props}/>`}
        <SolvedByWeek users={[props.user]} userList={props.user.userList} details={false}/>
        {
        res = []
        a =  (el) -> res.push(el)
        for result in props.results
            data =
                user: props.user
                results: result
            a <Table data={[data]} details={false} me={props.me} key={result[0]._id}/>
        res}
    </div>
