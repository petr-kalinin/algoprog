React = require('react')
moment = require('moment');
import {Link} from 'react-router-dom'

import Table from 'react-bootstrap/lib/Table'
import Checkbox from 'react-bootstrap/lib/Checkbox'

import Result from './Result'

import styles from './Result.css'


export default class Dashboard extends React.Component
    constructor: (props) ->
        super(props)
        @toggleUnknown = @toggleUnknown.bind(this)
        @state =
            showUnknown: false

    toggleUnknown: () ->
        @setState
            showUnknown: !@state.showUnknown

    render: () ->
        <div>
            <Checkbox checked={@state.showUnknown} onClick={@toggleUnknown}>
                Показывать unknown
            </Checkbox>
            {for type in ['ok', 'wa', 'ig', 'ac']
                <div key={type}>
                    <h1>{type.toUpperCase()}</h1>
                    <Table striped condensed hover>
                        <tbody>
                            {@props[type].map((result) =>
                                if result.user.userList != "unknown" or @state.showUnknown
                                    <Result result={result} key={result._id}/>
                                else
                                    null
                            )}
                        </tbody>
                    </Table>
                </div>
            }
            <div key="cf">
                <h1>CF</h1>
                <Table striped condensed hover>
                    <tbody>
                        {@props["cf"].map((result) ->
                            <tr key={result._id}>
                                <td className={styles.td}>{moment(result.time).format('YYYY-MM-DD kk:mm:ss')}</td>
                                <td className={styles.td}><Link to={"/user/" + result.user._id}>{result.user.name}</Link></td>
                                <td className={styles.td}>{result.contestId}</td>
                                <td className={styles.td}>
                                    {
                                        if result.user.cf?.login
                                            <a href={"http://codeforces.com/submissions/" + result.user.cf.login + "/contest/" + result.contestId}>
                                                {
                                                delta = result.newRating - result.oldRating
                                                if delta > 0
                                                    delta = "+" + delta
                                                delta + " (" + result.oldRating + " -> " + result.newRating + " / " + result.place + ")"}
                                            </a>
                                        else
                                            <div>Unknown cf login</div>
                                    }
                                    </td>
                            </tr>)}
                    </tbody>
                </Table>
            </div>
        </div>
