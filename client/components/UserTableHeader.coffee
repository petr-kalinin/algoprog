React = require('react')

import {LangRaw} from '../lang/lang'

import {getClassStartingFromJuly} from '../lib/graduateYearToClass'
import stripLabel from '../lib/stripLabel'

import globalStyles from './global.css'

import UserName from './UserName'
import CfStatus from './CfStatus'

# this is not a react element, as we can not return an array
export default userTableHeader = (res, props) ->
    h = props.header
    LANG = (id) -> LangRaw(id, props.lang)
    cls = if h then LANG("class")[0] else
        getClassStartingFromJuly(props.user.graduateYear) || ""
    if props.theme == 'dark'
        style = backgroundColor : "#707070"
    else
        style = backgroundColor : "white"
    a = (el) -> res.push(el)
    if props.details
        a <th className={globalStyles.mainTable_th + " " + globalStyles.mainTable_user} key="user" style={style}>
            {if h then "" else <UserName user={props.user} />}
        </th>
        a <td className={globalStyles.mainTable_td} key="graduateYear" title={LANG("class")}>
            {cls} 
        </td>
        a <td className={globalStyles.mainTable_td} key="level" title={LANG("level")}>
            {if h then LANG("level")[0] else stripLabel(props.user.level?.current)}
        </td>
        a <td className={globalStyles.mainTable_td} key="rating" title={LANG("rating")}>
            {if h then LANG("rating")[0] else props.user.rating}
        </td>
        a <td className={globalStyles.mainTable_td} key="activity" title={LANG("activity")}>
            {if h then LANG("activity")[0] else props.user.activity?.toFixed?(1)}
        </td>
        a <td className={globalStyles.mainTable_td} key="cf" title="Codeforces">
            {if h then "CF" else <CfStatus cf={props.user.cf}/>}
        </td>
    res
