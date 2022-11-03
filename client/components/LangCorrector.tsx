import React = require('react')

import { withRouter, Redirect } from 'react-router'

import correctUrl from '../lib/correctUrl'
//  @ts-ignore
import withLang from '../lib/withLang'

// @ts-ignore
import {LangRaw} from '../lang/lang'


function LangCorrector(props) {
    var label = LangRaw("material_suffix", props.lang)
    const url = props.location.pathname
    const newUrl = correctUrl(url, label)
    if (url != newUrl)
        return <Redirect to={newUrl}/>
    else
        return props.children
}

export default withLang(withRouter(LangCorrector))