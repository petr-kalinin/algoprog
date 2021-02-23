React = require('react')
import {
  BrowserRouter as Router,
  Route,
  Switch,
  Redirect
} from 'react-router-dom'

import DashboardPage from './pages/DashboardPage'
import EditUserPage from './pages/EditUserPage'
import LoginPage from './pages/LoginPage'
import RegisterPage from './pages/RegisterPage'
import RegisteredUsersPage from './pages/RegisteredUsersPage'
import ReviewResultPage from './pages/ReviewResultPage'
import RootPage from './pages/RootPage'

class NoMatch extends React.Component
    render: () ->
        return <h2>404 Not found</h2>

export default [
    {
        path: '/edituser/:id',
        key: "edituser",
        component: EditUserPage,
    },
    {
        path: '/dashboard',
        key: "dashboard",
        component: DashboardPage,
    },
    {
        path: '/reviewResult/:id',
        key: "reviewResult",
        component: ReviewResultPage,
    },
    {
        path: '/registeredUsers',
        key: "registeredUsers",
        component: RegisteredUsersPage,
    },
    {
        path: '/login',
        key: "login",
        component: LoginPage,
    },
    {
        path: '/register',
        key: "register",
        component: RegisterPage,
    },
    {
        path: '/',
        key: "/",
        exact: true,
        component: RootPage,
    },
    {
        component: NoMatch,
        key: "nomatch"
    },
]
