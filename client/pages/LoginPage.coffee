React = require('react')

import Login from '../components/Login'
import Sceleton from '../components/Sceleton'

class LoginPage extends React.Component
    render:  () ->
        sceletonProps = {@props..., location: {title: "Вход", _id: "login"}}
        `<Sceleton {...sceletonProps}><Login {...this.props}/></Sceleton>`

export default LoginPage
