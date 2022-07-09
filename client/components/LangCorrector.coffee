React = require('react')

import { withRouter, Redirect } from 'react-router'

import stripLabel from '../lib/stripLabel'
import withLang from '../lib/withLang'

isLevel = (url) ->
    data = url.split("/")
    if data.length != 3
        return false
    if data[0] != "" or data[1] != "material"
        return false
    level = data[2]
    return /^\d+[А-ГA-D]$/.test(level)

correctUrl = (url, lang) ->
    if not url.startsWith("/material/")
        return url
    url = stripLabel(url)
    if lang == "ru"
        if isLevel(url)
            url = url.replace("A", "А").replace("B", "Б").replace("C", "В").replace("D", "Г")
    else
        if isLevel(url)
            url = url.replace("А", "A").replace("Б", "B").replace("В", "C").replace("Г", "D")
        url = url + "!en"
    return url

export default LangCorrector = withLang withRouter (props) ->
    url = props.location.pathname
    newUrl = correctUrl(url, props.lang)
    if url != newUrl
        <Redirect to={newUrl}/>
    else
        props.children
