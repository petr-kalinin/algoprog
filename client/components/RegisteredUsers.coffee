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
        @handleChange = @handleChange.bind(this)
        @handleSearchUserChange = @handleSearchUserChange.bind(this)
        @handlefoundUserChange = @handlefoundUserChange.bind(this)
        @handleKeyPressed = @handleKeyPressed.bind(this)
        @handleSubmit = @handleSubmit.bind(this)

    startState: (props) ->
        return
            searchUser: props.searchUser || '',
            foundUser: props.foundUser || props.users

    handleChange: (field, event) ->
        newState = deepcopy(@state)
        newState[field] = event.target.value
        @setState(newState)

    handleSearchUserChange: (event) ->
        @handleChange("searchUser", event)

    handlefoundUserChange: (event) ->
        @handleChange("foundUser", event)

    handleSubmit: (event) ->
        event.preventDefault()
        console.log("111@state.foundUser = ",@state.foundUser)
        newState = await callApi "searchUser", {searchUser: @state.searchUser}
        console.log("newState = ",newState)
        @setState({foundUser: newState})

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
                        size="10"
                        onChange={@handleSearchUserChange}
                        onKeyPress={@handleKeyPressed} />
                </div>
            </form>
            <Table striped condensed hover>
                <tbody>
                    {@state.foundUser.map?((user) ->
                        <tr key={user.username}>
                            <td>
                                {user.fullName || "***"}
                            </td>
                            <td>
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
                                {user.informaticsUsername}
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
