React = require('react')
moment = require('moment');
import {Link} from 'react-router-dom'

import styles from './Result.css'

makeUserName = (user) ->
    star = ""
    if user.userList == "stud"
        star = "*"
    if user.userList == "unknown"
        star = "(u) "
    star + user.name + " (" + user.level.current + ")"

export default Result = (props) ->
    r = props.result
    problem = r.table._id.substr(1)
    href =  'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=' + problem + '&submit&user_id=' + r.user._id
    userHref = "/user/" + r.user._id
    problemHref = '/material/' + r.table._id
    problemName = r.table.name
    contests = r.table.tables
    userName = makeUserName(r.user)
    return
        <tr>
            <td className={styles.td} style={{whiteSpace: "nowrap"}}>
                <a href={href} target="_blank">{moment(r.lastSubmitTime).format('YYYY-MM-DD HH:mm:ss')}</a>
                {" "}[ x {r.attempts} ]
                {" "}<Link to="/submit/#{r.lastSubmitId}">{"#"}</Link>
            </td>
            <td className={styles.td} style={{whiteSpace: "nowrap"}}>
                <Link to={userHref}>{userName}</Link>
            </td>
            <td className={styles.td}>
                <Link to={problemHref}>{problemName}</Link>
            </td>
            <td className={styles.td} style={{whiteSpace: "pre-wrap"}}>
                {contests.join("\n")}
            </td>
        </tr>
