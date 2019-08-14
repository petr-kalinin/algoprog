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
    className = styles.achieve
    if props.big
        className += " " + styles.big
    else
        achieves.sort((a, b) -> b.score - a.score)
        achieves = achieves[..2]
    <div>
        {achieves.map((achieve) -> <div title={achieve.title} className={className} style={{background: achieve.color}} key={achieve.key}>{achieve.text}</div>)}
    </div>

export BigAchieves = (props) ->
    `<Achieves {...props} big={true}/>`