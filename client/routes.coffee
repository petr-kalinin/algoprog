React = require('react')
import {
  BrowserRouter as Router,
  Route,
  Switch,
  Redirect
} from 'react-router-dom'

import UserBadgePage from './pages/UserBadgePage'
import FullUserPage from './pages/FullUserPage'
import DashboardPage from './pages/DashboardPage'
import TablePage from './pages/TablePage'
import MaterialPage from './pages/MaterialPage'
import SolvedByWeekPage from './pages/SolvedByWeekPage'
import RootPage from './pages/RootPage'
import FullNewsPage from './pages/FullNewsPage'
import RegisterPage from './pages/RegisterPage'

import Login from './components/Login'

class NoMatch extends React.Component
    render: () ->
        return <h2>404 Not found</h2>

export default [
    {
        path: '/userBadge/:id',
        key: "userBadge",
        component: UserBadgePage,
    },
    {
        path: '/user/:id',
        key: "user",
        component: FullUserPage,
    },
    {
        path: '/table/:userList/:id',
        key: "table",
        component: TablePage
    },
    {
        path: '/dashboard',
        key: "dashboard",
        component: DashboardPage,
    },
    {
        path: '/solvedByWeek/:userList',
        key: "solvedByWeek",
        component: SolvedByWeekPage,
    },
    {
        path: '/material/:id',
        key: "material",
        component: MaterialPage,
    },
    {
        path: '/news',
        key: "news",
        component: FullNewsPage,
    },
    {
        path: '/login',
        key: "login",
        component: Login,
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
