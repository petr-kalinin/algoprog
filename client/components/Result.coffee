React = require('react')
moment = require('moment');

makeUserName = (user) ->
    star = ""
    if user.userList == "stud"
        star = "*"
    star + user.name + " (" + user.level + ")"    

export default Submit = (props) ->
    r = props.result
    problem = r.table._id.substr(1)
    href =  'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=' + problem + '&submit&user_id=' + r.user._id
    userHref = "/user/" + r.user._id
    problemHref = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=' + problem
    problemName = r.table.name
    contests = r.table.tables
    userName = makeUserName(r.user)
    return 
        <tr>
            <td>
                <a href={href} target="_blank">{moment(r.lastSubmitTime).format('YYYY-MM-DD kk:mm:ss')}</a>
                &nbsp;[ x {r.attempts} ]
            </td>
            <td>
                <a href={userHref}>{userName}</a>
            </td>
            <td>
                <a href={problemHref}>{problemName}</a>
            </td>
            <td>
                {contests.join(", ")}
            </td>
        </tr>
