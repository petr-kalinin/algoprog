React = require('react')

import Register from '../components/Register'
import Sceleton from '../components/Sceleton'

import {LangRaw} from '../lang/lang'
import withLang from '../lib/withLang'

class RegisterPage extends React.Component
    render:  () ->
        sceletonProps = {@props..., location: {title: LangRaw("register", @props.lang), _id: "register"}}
        `<Sceleton {...sceletonProps}><Register {...this.props}/></Sceleton>`

export default withLang RegisterPage
