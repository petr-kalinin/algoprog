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
    if props.details
        a <td className={globalStyles.mainTable_td} key="level" title="Уровень">
            {if h then "У" else props.user.level?.current}
        </td>
        a <td className={globalStyles.mainTable_td} key="rating" title="Рейтинг">
            {if h then "Р" else props.user.rating}
        </td>
        a <td className={globalStyles.mainTable_td} key="activity" title="Активность">
            {if h then "А" else props.user.activity?.toFixed?(1)}
        </td>
        a <td className={globalStyles.mainTable_td} key="cf" title="Codeforces">
            {if h then "CF" else <CfStatus cf={props.user.cf}/>}
        </td>
        a <td className={globalStyles.mainTable_td} key="graduateYear" title="Класс">
            {if h then "К" else props.user.graduateYear}
        </td>
    res
