React = require('react')
tinycolor = require("tinycolor2")

import styles from './UserName.css'
import { Link } from 'react-router-dom'
import { connect } from 'react-redux'

import {LEVEL_RATING_EXP, ACTIVITY_THRESHOLD} from '../../server/calculations/ratingConstants'
MAX_ACTIVITY = 7
MAX_RATING = 10 * (Math.pow(LEVEL_RATING_EXP, 11) - 1) / (LEVEL_RATING_EXP - 1)

export color = (user,theme) ->
    activity = Math.min(user.activity + 1, MAX_ACTIVITY + 1)
    rating = Math.min(user.rating + 1, MAX_RATING + 1)
    h = 11/12 * (1 - Math.log(rating) / Math.log(MAX_RATING + 1))
    s = 1
    v = 0.3 + 0.7 * Math.log(activity) / Math.log(MAX_ACTIVITY + 1)
    if user.activity < ACTIVITY_THRESHOLD
        v = 0
    if theme == "dark"
        h = 56
        s = 13
        v = 97
    return "#" + tinycolor.fromRatio({h: h, s: s, v: v}).toHex()

UserName = (props) ->
    <Link to={"/user/" + props.user._id}>
        <span className={styles.name} style={ {color:  color(props.user,props.theme)} }>
            {props.user.name}
        </span>
    </Link>

mapStateToProps = (state) ->
    return
        theme: state.theme

export default connect(mapStateToProps)(UserName)
