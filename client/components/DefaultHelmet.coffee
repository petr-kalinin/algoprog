React = require('react')

import {Helmet} from 'react-helmet'

import {LangRaw} from '../lang/lang'
import withLang from '../lib/withLang'

DefaultHelmet = (props) ->
    <Helmet titleTemplate={"%s — " + LangRaw("domain", props.lang)} defaultTitle={LangRaw("default_title", props.lang)}>
    </Helmet>

export default withLang(DefaultHelmet)
