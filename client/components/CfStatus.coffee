React = require('react')

import styles from './CfStatus.css'

export default class CfStatus extends React.Component 
    render:  () ->
        cf = @props.cf;
        
        cfProgressColor = "inherit"
        if cf.progress > 10
            cfProgressColor = "#00aa00"
        else if cf.progress < -10
            cfProgressColor = "#aa0000"

        return 
            <span>
                <a href={"http://codeforces.com/profile/" + cf.login}>
                    <span className={styles.color} style={color: cf.color}>
                        {cf.rating}
                    </span>
                </a>
                &nbsp;(
                <span className={styles.progress} title="Взвешенный прирост рейтинга за последнее время" style={color: cfProgressColor}>
                    {(if cf.progress > 0 then "+" else "") + cf.progress.toFixed(1)}
                </span>
                /
                <span title="Взвешенное количество написанных контестов за последнее время">
                    {cf.activity.toFixed(1)}
                </span>
                )
            </span>
