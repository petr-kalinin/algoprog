React = require('react')
tinycolor = require("tinycolor2")

import styles from './UserName.css'
import { Link } from 'react-router-dom'

import {Achieves} from './Achieves'

import {LEVEL_RATING_EXP, ACTIVITY_THRESHOLD} from '../../server/calculations/ratingConstants'
MAX_ACTIVITY = 7
MAX_RATING = 10 * (Math.pow(LEVEL_RATING_EXP, 11) - 1) / (LEVEL_RATING_EXP - 1)

export color = (user) ->
    activity = Math.min(user.activity + 1, MAX_ACTIVITY + 1)
    rating = Math.min(user.rating + 1, MAX_RATING + 1)
    h = 11/12 * (1 - Math.log(rating) / Math.log(MAX_RATING + 1))
    v = 0.3 + 0.7 * Math.log(activity) / Math.log(MAX_ACTIVITY + 1)
    if user.activity < ACTIVITY_THRESHOLD
        v = 0
    return "#" + tinycolor.fromRatio({h: h, s: 1, v: v}).toHex()


export default UserName = (props) ->
    <span>
        <Link to={"/user/" + props.user._id}>
            <span className={styles.name} style={ {color:  color(props.user)} }>
                {props.user.name}
            </span>
        </Link>
        {props.noachieves || <Achieves achieves={props.user.achieves} />}
    </span>
