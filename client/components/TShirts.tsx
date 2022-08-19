const React = require('react')

//  @ts-ignore
import {LangRaw} from '../lang/lang'
//  @ts-ignore
import withLang from '../lib/withLang'
import {parseLevel} from '../lib/level'

function calcTShirts(user) {
    const levelStr = user.level?.current || "0A"
    const level = parseLevel(levelStr)
    var number = level.major
    if (level.minor >= 2)
        number++
    if (number >= 12)
        return 5
    else if (number >= 10)
        return 4
    else if (number >= 8)
        return 3
    else if (number >= 6)
        return 2
    else if (number >= 4)
        return 1
    else
        return 0
}

const COLORS = ["", "#8000ff", "#0040ff", "#ff8000", "#ff0000", "#000000"]

 function TShirts(props) {
    const cnt = calcTShirts(props.user)
    const got = props.user.tshirtsGot
    return <span>
        {
        (() => {
            var res = []
            var a = (el) => res.push(el)
            if (cnt)
                for (let n = 1; n <= cnt; n++) {
                    const style = {color: "transparent", textShadow: "0 0 0 " + COLORS[n], cursor: "hand"}
                    var title = props.title
                    if (n <= got) {
                        if (props.hideGot)
                            continue
                        style["filter"] = "blur(2px) opacity(30%)"
                        title = title || LangRaw("already_got", props.lang)
                    }
                    a(<span key={n} onClick={props.onClick?.(n)} style={style} title={title}>👕</span>)
                }
            return res
        })()}
    </span>
 }

export default withLang(TShirts)