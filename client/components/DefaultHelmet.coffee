React = require('react')

import {Helmet} from 'react-helmet'

import withLang from '../lib/withLang'

DefaultHelmet = (props) ->
    if props.lang == "ru"
        <Helmet titleTemplate="%s — algoprog.ru" defaultTitle="Алгоритмическое программирование">
        </Helmet>
    else
        <Helmet titleTemplate="%s — algoprog.org" defaultTitle="Algorithmic programming">
        </Helmet>

export default withLang(DefaultHelmet)
