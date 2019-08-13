React = require('react')

import styles from './Achieves.css'

import ACHIEVES from '../lib/achieves'

expandAchieve = (key) ->
    if key of ACHIEVES
        achieve = ACHIEVES[key]
    else
        achieve = ACHIEVES["unknown"]
        achieve.title = key
    achieve.key = key
    return achieve


export Achieves = (props) ->
    if not props.achieves
        return null
    achieves = props.achieves.map(expandAchieve)
    <div>
        {achieves.map((achieve) -> <span title={achieve.title} className={styles.achieve} style={{background: achieve.color}} key={achieve.key}>{achieve.text}</span>)}
    </div>

export BigAchieves = Achieves