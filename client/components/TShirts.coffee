React = require('react')

import {LangRaw} from '../lang/lang'
import withLang from '../lib/withLang'

calcTShirts = (user) ->
    level = user.level?.current || 0
    letter = level.slice(-1)
    number = +level.slice(0, -1)
    if letter >= "В" || (letter >= "C" && letter < "Z")
        number++
    if number >= 12
        return 5
    else if number >= 10
        return 4
    else if number >= 8
        return 3
    else if number >= 6
        return 2
    else if number >= 4
        return 1
    else
        return 0

COLORS = ["", "#8000ff", "#0040ff", "#ff8000", "#ff0000", "#000000"]

export default withLang TShirts = (props) ->
    cnt = calcTShirts(props.user)
    got = props.user.tshirtsGot
    <span>
        {
        res = []
        a = (el) -> res.push(el)
        if cnt
            for n in [1..cnt]
                style = {color: "transparent", textShadow: "0 0 0 " + COLORS[n], cursor: "hand"}
                title = props.title
                if n <= got
                    if props.hideGot
                        continue
                    style["filter"] = "blur(2px) opacity(30%)"
                    title = title || LangRaw("already_got", props.lang)
                a <span key={n} onClick={props.onClick?(n)} style={style} title={title}>👕</span>
        res}
    </span>
