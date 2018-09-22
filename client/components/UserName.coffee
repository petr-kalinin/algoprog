React = require('react')
tinycolor = require("tinycolor2")

import styles from './UserName.css'
import { Link } from 'react-router-dom'

import {LEVEL_RATING_EXP, ACTIVITY_THRESHOLD} from '../../server/calculations/ratingConstants'
MAX_ACTIVITY = 7
MAX_RATING = 10 * (Math.pow(LEVEL_RATING_EXP, 11) - 1) / (LEVEL_RATING_EXP - 1)
MAX_POINTS = 1600

export color = (user) ->
    points = Math.min(user.points + 1, MAX_POINTS + 1)
    h = 11/12 * (1 - Math.log(points) / Math.log(MAX_RATING + 1))
    v = 1
    return "#" + tinycolor.fromRatio({h: h, s: 1, v: v}).toHex()


export default UserName = (props) ->
    <Link to={"/user/" + props.user._id}>
        <span className={styles.name} style={ {color:  color(props.user)} }>
            {props.user.name}
        </span>
    </Link>
