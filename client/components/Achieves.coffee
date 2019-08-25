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
    achieves.sort((a, b) -> b.score - a.score)
    if props.inverse
        achieves.reverse()
    if props.big
        className += " " + styles.big
    else
        achieves = achieves[..2]
    <div className={styles.achieves}>
        {achieves.map((achieve) -> <div title={(if props.score then "(#{achieve.score}) " else "") + achieve.title} className={className} style={{background: achieve.color}} key={achieve.key}>{achieve.text}</div>)}
    </div>

export BigAchieves = (props) ->
    `<Achieves {...props} big={true}/>`

export AllAchieves = (props) ->
    allAchieves = []
    for key, value of ACHIEVES
        if key != "unknown"
            allAchieves.push(key)
    <Achieves achieves={allAchieves} inverse={true} big={true} score={true}/>