import React = require('react')

import { withRouter, Redirect } from 'react-router'

import {parseLevel, encodeLevel} from '../lib/level'
//  @ts-ignore
import withLang from '../lib/withLang'
import stripLabel from '../lib/stripLabel'

// @ts-ignore
import {LangRaw} from '../lang/lang'

function correctUrl(url: string, lang: string) {
    if (!url.startsWith("/material/"))
        return url
    const data = url.split("/")
    if (data.length != 3) 
        return url
    var label = LangRaw("material_suffix", lang)
    const level = parseLevel(data[2])
    if (!level)
        return stripLabel(url) + label
    return "/material/" + encodeLevel(level, label)
}

function LangCorrector(props) {
    const url = props.location.pathname
    const newUrl = correctUrl(url, props.lang)
    if (url != newUrl)
        return <Redirect to={newUrl}/>
    else
        return props.children
}

export default withLang(withRouter(LangCorrector))