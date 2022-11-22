React = require('react')
import { Link } from 'react-router-dom'

import styles from './Achieves.css'

import {LangRawAny} from '../lang/lang'

import ACHIEVES from '../lib/achieves'
import withLang from '../lib/withLang'

expandAchieve = (key) ->
    if key of ACHIEVES
        achieve = ACHIEVES[key]
    else
        achieve = ACHIEVES["unknown"]
        achieve.title = key
    achieve.key = key
    return achieve


export Achieves = withLang (props) ->
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
        {achieves.map((achieve, index) ->
            <Link to="/usersWithAchieve/#{achieve.key}" key={achieve.key + index}> 
                <div title={(if props.score then "(#{achieve.score}) " else "") + LangRawAny(achieve.title, props.lang, achieve.key)} className={className} style={{background: achieve.color}}>
                    {LangRawAny(achieve.text, props.lang, achieve.key)}
                </div>
            </Link>
        )}
    </div>

export BigAchieves = (props) ->
    `<Achieves {...props} big={true}/>`

export AllAchieves = (props) ->
    allAchieves = []
    for key, value of ACHIEVES
        if key != "unknown"
            allAchieves.push(key)
    <Achieves achieves={allAchieves} inverse={true} big={true} score={true}/>