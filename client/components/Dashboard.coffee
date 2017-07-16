React = require('react')

import styles from './Dashboard.css'

import Result from './Result'

export default Dashboard = (props) ->
    return 
        <div>
            <h1>OK</h1>
            <table className={styles.table}>
                <tbody>
                    {props.ok.map((result) ->
                        <Result result={result} key={result._id}/>
                    )}
                </tbody>
            </table>
        </div>
            
