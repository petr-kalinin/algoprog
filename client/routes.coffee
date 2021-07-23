React = require('react')
import {
  BrowserRouter as Router,
  Route,
  Switch,
  Redirect
} from 'react-router-dom'

import ContestPage from './pages/ContestPage'
import DashboardPage from './pages/DashboardPage'
import EditUserPage from './pages/EditUserPage'
import LoginPage from './pages/LoginPage'
import LoginAsTeamPage from './pages/LoginAsTeam'
import ProblemPage from './pages/ProblemPage'
import RegisterPage from './pages/RegisterPage'
import RegisteredUsersPage from './pages/RegisteredUsersPage'
import ReviewResultPage from './pages/ReviewResultPage'
import RootPage from './pages/RootPage'

class NoMatch extends React.Component
    render: () ->
        return <h2>404 Not found</h2>

BASE_ROUTES = [
    {
        path: '/contest/:id',
        component: ContestPage,
    },
    {
        path: '/problem/:id',
        component: ProblemPage,
    },

    {
        path: '/edituser/:id',
        component: EditUserPage,
    },
    {
        path: '/dashboard',
        component: DashboardPage,
    },
    {
        path: '/reviewResult/:id',
        component: ReviewResultPage,
    },
    {
        path: '/registeredUsers',
        component: RegisteredUsersPage,
    },
    {
        path: '/login',
        component: LoginPage,
    },
    {
        path: '/loginAsTeam',
        component: LoginAsTeamPage,
    },
    {
        path: '/register',
        component: RegisterPage,
    },
    {
        path: '/',
        exact: true,
        component: RootPage,
    },
    {
        component: NoMatch,
    },
]

export default routes = BASE_ROUTES.map((route) => {
        path: if route.path then [route.path, "(.*)https/algoprog.ru" + route.path] else route.path
        key: route.path || "-"
        component: route.component
        exact: route.exact
    }
)