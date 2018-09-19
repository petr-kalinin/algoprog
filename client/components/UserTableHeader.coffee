React = require('react')

import globalStyles from './global.css'

import UserName from './UserName'
import CfStatus from './CfStatus'

# this is not a react element, as we can not return an array
export default userTableHeader = (res, props) ->
    h = props.header
    a = (el) -> res.push(el)
    a <td className={globalStyles.mainTable_td + " " + globalStyles.mainTable_user} key="user">
        {if h then "" else <UserName user={props.user} />}
    </td>
    res
