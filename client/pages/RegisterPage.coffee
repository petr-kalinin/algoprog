React = require('react')

import Register from '../components/Register'
import Sceleton from '../components/Sceleton'

import ConnectedComponent from './ConnectedComponent'

class RegisterPage extends React.Component
    render:  () ->
        sceletonProps = {@props..., location: {title: "Регистрация", _id: "register"}}
        `<Sceleton {...sceletonProps}><Register {...this.props}/></Sceleton>`

export default ConnectedComponent(RegisterPage)
