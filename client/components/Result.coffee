React = require('react')
moment = require('moment');
FontAwesome = require('react-fontawesome')
import {Link} from 'react-router-dom'

import styles from './Result.css'

makeUserName = (user) ->
    star = ""
    if user.userList == "stud"
        star = "*"
    if not user?.activated
        star = "(na) "
    star + user.name + " (" + user.level?.current + ")"

export default Result = (props) ->
    r = props.result
    userHref = "/user/" + r.fullUser._id
    problemHref = '/material/' + r.fullTable._id
    problemName = r.fullTable.name
    contests = r.fullTable.tables
    userName = makeUserName(r.fullUser)
    return <tr>
            <td className={styles.td} style={{whiteSpace: "nowrap"}}>
                <Link to="/reviewResult/#{r._id}">{moment(r.lastSubmitTime).format('YYYY-MM-DD HH:mm:ss')}</Link>
                {" "}[ x {r.attempts} ]
                {" "}
                {r.fullSubmit?.comments?.length && <FontAwesome name="comment"/>|| ""}
            </td>
            <td className={styles.td} style={{whiteSpace: "nowrap"}}>
                <Link to={userHref}>{userName}</Link>
            </td>
            <td className={styles.td}>
                <Link to={problemHref}>{problemName}</Link>
            </td>
            <td className={styles.td} style={{whiteSpace: "pre-wrap"}}>
                {contests?.join("\n")}
            </td>
        </tr>
