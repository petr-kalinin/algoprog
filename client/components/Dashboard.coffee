React = require('react')
moment = require('moment');
import {Link} from 'react-router-dom'

import Table from 'react-bootstrap/lib/Table'
import Checkbox from 'react-bootstrap/lib/Checkbox'

import Result from './Result'

import styles from './Result.css'

import ConnectedComponent from '../lib/ConnectedComponent'


Stats = (props) ->
    <span>{props.stats.ok && "Downloads: ok #{props.stats.ok.toFixed(2)}, failed #{props.stats.fail.toFixed(2)}, ip #{props.stats.ip}"}</span>

options = {
    urls: (props) ->
        return
            stats: "downloadingStats"

    timeout: 20000
}

ConnectedStats = ConnectedComponent(Stats, options)



export default class Dashboard extends React.Component
    constructor: (props) ->
        super(props)

    render: () ->
        <div>
            <h4><ConnectedStats/></h4>
            {for type in ['ok', 'ps', 'wa', 'ig', 'ac', 'fm_ok', 'fm_wa']
                <div key={type}>
                    <h1>{type.toUpperCase()}</h1>
                    <Table striped condensed hover>
                        <tbody>
                            {@props[type].map((result) =>
                                <Result result={result} key={result._id}/>
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
                                <td className={styles.td}><Link to={"/user/" + result.fullUser._id}>{result.fullUser.name}</Link></td>
                                <td className={styles.td}>{result.contestId}</td>
                                <td className={styles.td}>
                                    {
                                        if result.fullUser.cf?.login
                                            <a href={"https://codeforces.com/submissions/" + result.fullUser.cf.login + "/contest/" + result.contestId}>
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
