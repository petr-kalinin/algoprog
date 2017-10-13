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
import SubmitPage from './pages/SubmitPage'
import RootPage from './pages/RootPage'
import FullNewsPage from './pages/FullNewsPage'
import ReviewPage from './pages/ReviewPage'
import RegisteredUsersPage from './pages/RegisteredUsersPage'
import RegisterPage from './pages/RegisterPage'
import LoginPage from './pages/LoginPage'

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
        path: '/review',
        key: "review",
        component: ReviewPage,
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
        path: '/submit/:id',
        key: "submit",
        component: SubmitPage,
    },
    {
        path: '/news',
        key: "news",
        component: FullNewsPage,
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
        path: '/stud',
        key: "/stud",
        component: RootPage,
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
