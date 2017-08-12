React = require('react')
moment = require('moment');
import {Link} from 'react-router-dom'

import Result from './Result'

import styles from './Result.css'


export default Dashboard = (props) ->
    return 
        <div>
            {for type in ['ok', 'wa', 'ig', 'ac']
                <div key={type}>
                    <h1>{type.toUpperCase()}</h1>
                    <table>
                        <tbody>
                            {props[type].map((result) ->
                                <Result result={result} key={result._id}/>
                            )}
                        </tbody>
                    </table>
                </div>
            }
            <div key="cf">
                <h1>CF</h1>
                <table>
                    <tbody>
                        {props["cf"].map((result) ->
                            <tr key={result._id}>
                                <td className={styles.td}>{moment(result.time).format('YYYY-MM-DD kk:mm:ss')}</td>
                                <td className={styles.td}><Link to={"/user/" + result.user._id}>{result.user.name}</Link></td>
                                <td className={styles.td}>{result.contestId}</td>
                                <td className={styles.td}><a href={"http://codeforces.com/submissions/" + result.user.cf.login + "/contest/" + result.contestId}>
                                    {        
                                    delta = result.newRating - result.oldRating
                                    if delta > 0
                                        delta = "+" + delta
                                    delta + " (" + result.oldRating + " -> " + result.newRating + " / " + result.place + ")"}
                                </a></td>
                            </tr>)}
                    </tbody>
                </table>
            </div>
        </div>
            
