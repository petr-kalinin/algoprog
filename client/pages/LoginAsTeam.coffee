React = require('react')

import LoginAsTeam from '../components/LoginAsTeam'
import Sceleton from '../components/Sceleton'

class LoginPage extends React.Component
    render:  () ->
        sceletonProps = {@props..., location: {title: "Войти как команда", _id: "loginAsTeam"}}
        `<Sceleton {...sceletonProps}><LoginAsTeam {...this.props}/></Sceleton>`

export default LoginPage
