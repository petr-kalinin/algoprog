React = require('react')

import Login from '../components/Login'
import Sceleton from '../components/Sceleton'

import {LangRaw} from '../lang/lang'
import withLang from '../lib/withLang'

class LoginPage extends React.Component
    render:  () ->
        sceletonProps = {@props..., location: {title: LangRaw("sign_in", @props.lang), _id: "login"}}
        `<Sceleton {...sceletonProps}><Login {...this.props}/></Sceleton>`

export default withLang(LoginPage)
