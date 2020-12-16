React = require('react')
deepcopy = require("deepcopy")
moment = require('moment')

import { Link } from 'react-router-dom'
import { Table } from 'react-bootstrap'

import callApi from '../lib/callApi'

export default class RegisteredUsers extends React.Component
    constructor: (props) ->
        super(props)
        @state = @startState(props)
        @handleSearchStringChange = @handleSearchStringChange.bind(this)
        @handleKeyPressed = @handleKeyPressed.bind(this)
        @handleSubmit = @handleSubmit.bind(this)

    startState: (props) ->
        return
            searchString: props.searchString || '',
            foundUsers: props.users

    handleSearchStringChange: (event) ->
        @setState({searchString: event.target.value})

    handleSubmit: (event) ->
        event.preventDefault()
        if not @state.searchString
            foundUsers = await callApi "registeredUsers",
        else
            foundUsers = await callApi "searchUser", {searchString: @state.searchString}
        @setState({foundUsers: foundUsers})

    handleKeyPressed: (e) ->
        if e.key == "Enter"
            @handleSubmit(e)

    render: () ->
        <div>
            <form onSubmit={@handleSubmit}>
                <div>
                    Поиск: <input
                        type="text"
                        name="search"
                        size="35"
                        onChange={@handleSearchStringChange}
                        onKeyPress={@handleKeyPressed} />
                </div>
            </form>
            <Table striped condensed hover>
                <tbody>
                    {@state.foundUsers.map?((user) ->
                        <tr key={user.username}>
                            <td>
                                {user.fullName || "***"}
                            </td>
                            <td>
                                {if user.activated then "" else "(na)"}
                                {if user.dormant then "(d)" else ""}
                                {" "}
                                {user.username}
                            </td>
                            <td>
                                {user.userList}
                            </td>
                            <td>
                                {user.registerDate && moment(user.registerDate).format('YYYY-MM-DD kk:mm:ss') || "—"}
                            </td>
                            <td>
                                <Link to={"/user/#{user.informaticsId}"}>{user.informaticsId}</Link>
                            </td>
                            <td>
                                (inf=){user.informaticsUsername}
                            </td>
                            <td>
                                {user.aboutme}
                            </td>
                            <td>
                                {user.promo}
                            </td>
                            <td>
                                {user.contact}
                            </td>
                            <td>
                                {user.whereFrom}
                            </td>
                            <td>
                                <a href={"https://informatics.msk.ru/user/view.php?id=#{user.informaticsId}&course=1"}>{"#"}</a>
                            </td>
                        </tr>
                    )}
                </tbody>
            </Table>
        </div>
