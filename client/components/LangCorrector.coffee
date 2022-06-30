React = require('react')

import { withRouter, Redirect } from 'react-router'

import stripLabel from '../lib/stripLabel'
import withLang from '../lib/withLang'

correctUrl = (url, lang) ->
    if not url.startsWith("/material/")
        return url
    url = stripLabel(url)
    if lang == "ru"
        return url #.replace("A", "А").replace("B", "Б").replace("C", "В").replace("D", "Г")
    else
        return url + "!en" #.replace("А", "A").replace("Б", "B").replace("В", "C").replace("Г", "D") + "!en"

export default LangCorrector = withLang withRouter (props) ->
    url = props.location.pathname
    newUrl = correctUrl(url, props.lang)
    if url != newUrl
        <Redirect to={newUrl}/>
    else
        props.children
