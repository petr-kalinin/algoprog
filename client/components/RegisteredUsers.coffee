React = require('react')

import { Link } from 'react-router-dom'
import { Table } from 'react-bootstrap'

export default RegisteredUsers = (props) ->
    <Table striped condensed hover>
        <tbody>
            {props.users.map?((user) ->
                <tr key={user.username}>
                    <td>
                        {user.fullName || "***"}
                    </td>
                    <td>
                        {user.username}
                    </td>
                    <td>
                        <Link to={"/user/#{user.informaticsId}"}>{user.informaticsId}</Link>
                    </td>
                    <td>
                        {user.informaticsUsername}
                    </td>
                    <td>
                        {user.aboutme}
                    </td>
                    <td>
                        <a href={"https://informatics.mccme.ru/user/view.php?id=#{user.informaticsId}&course=1"}>{"#"}</a>
                    </td>
                </tr>
            )}
        </tbody>
    </Table>
