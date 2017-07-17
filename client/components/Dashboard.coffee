React = require('react')

import styles from './Dashboard.css'

import Result from './Result'

export default Dashboard = (props) ->
    return 
        <div>
            {for type in ['ok', 'wa', 'ig', 'ac']
                <div key={type}>
                    <h1>{type}</h1>
                    <table className={styles.table}>
                        <tbody>
                            {props[type].map((result) ->
                                <Result result={result} key={result._id}/>
                            )}
                        </tbody>
                    </table>
                </div>
            }
        </div>
            
