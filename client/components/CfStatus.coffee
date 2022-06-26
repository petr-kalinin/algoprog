React = require('react')

import {LangRaw} from '../lang/lang'
import withLang from '../lib/withLang'

import styles from './CfStatus.css'

class CfStatus extends React.Component
    render:  () ->
        cf = @props.cf

        if not cf or not cf.login or not cf.rating
            return null

        cfProgressColor = "inherit"
        if cf.progress > 10
            cfProgressColor = "#00aa00"
        else if cf.progress < -10
            cfProgressColor = "#aa0000"

        return <span>
                <a href={"https://codeforces.com/profile/" + cf.login} title={LangRaw("cf_rating", @props.lang)}>
                    <span className={styles.color} style={color: cf.color}>
                        {cf.rating}
                    </span>
                </a>
                &nbsp;(
                <span className={styles.progress} title={LangRaw("cf_progress", @props.lang)} style={color: cfProgressColor}>
                    {(if cf.progress > 0 then "+" else "") + cf.progress.toFixed(1)}
                </span>
                /
                <span title={LangRaw("cf_activity", @props.lang)}>
                    {cf.activity.toFixed(1)}
                </span>
                )
            </span>

export default withLang(CfStatus)