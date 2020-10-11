React = require('react')
tinycolor = require("tinycolor2")

import styles from './UserName.css'
import { Link } from 'react-router-dom'
import withTheme from '../lib/withTheme'

import {Achieves} from './Achieves'

import {LEVEL_RATING_EXP, ACTIVITY_THRESHOLD} from '../../server/calculations/ratingConstants'

MAX_ACTIVITY = 7

MAX_RATING = 4500000
MAX_LEVEL = 13
REFERENCE_LEVEL = 2
REFERENCE_RATING = 600
RATING_OFFSET = 200
RATING_K = (MAX_LEVEL - REFERENCE_LEVEL) / (Math.log(MAX_RATING + RATING_OFFSET) - Math.log(REFERENCE_RATING + RATING_OFFSET))
RATING_B = REFERENCE_LEVEL - RATING_K * Math.log(REFERENCE_RATING + RATING_OFFSET)

hue = (rating) ->
    level = RATING_K * Math.log(rating + RATING_OFFSET) + RATING_B
    if level < 0
        level = 0
    if level > MAX_LEVEL
        level = MAX_LEVEL
    return 10 / 12 * (1 - level / MAX_LEVEL)

export color = (user, theme) ->
    activity = Math.min(user.activity + 1, MAX_ACTIVITY + 1)
    h = hue(user.rating)
    s = 1
    v = 0.3 + 0.7 * Math.log(activity) / Math.log(MAX_ACTIVITY + 1)
    if user.activity < ACTIVITY_THRESHOLD
        v = 0
    if theme == "dark"
        h = 56
        s = 13
        v = 97
    return "#" + tinycolor.fromRatio({h: h, s: s, v: v}).toHex()

export UserNameRaw = (props) ->
    <span>
        <Link to={"/user/" + props.user._id}>
            <span className={styles.name} style={ {color:  color(props.user,props.theme)} }>
                {props.user.name}
            </span>
        </Link>
        {props.noachieves || <span> <Achieves achieves={props.user.achieves} /></span>}
    </span>

export default withTheme(UserNameRaw)
