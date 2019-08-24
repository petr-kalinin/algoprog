React = require('react')
import {
  BrowserRouter as Router,
  Route,
  Switch,
  Redirect
} from 'react-router-dom'

import AchievesPage from './pages/AchievesPage'
import UserBadgePage from './pages/UserBadgePage'
import FullUserPage from './pages/FullUserPage'
import DashboardPage from './pages/DashboardPage'
import CheckinsPage from './pages/CheckinsPage'
import TablePage from './pages/TablePage'
import MaterialPage from './pages/MaterialPage'
import SolvedByWeekPage from './pages/SolvedByWeekPage'
import SubmitPage from './pages/SubmitPage'
import ReviewResultPage from './pages/ReviewResultPage'
import RootPage from './pages/RootPage'
import FullNewsPage from './pages/FullNewsPage'
import ReviewPage from './pages/ReviewPage'
import PaymentPage from './pages/PaymentPage'
import PaymentSuccessPage from './pages/PaymentSuccessPage'
import RegisteredUsersPage from './pages/RegisteredUsersPage'
import RegisterPage from './pages/RegisterPage'
import LoginPage from './pages/LoginPage'

class NoMatch extends React.Component
    render: () ->
        return <h2>404 Not found</h2>

class PayPage extends React.Component
    render: () ->
        return <Redirect to="/material/pay" />

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
        path: '/checkins',
        key: "checkins",
        component: CheckinsPage,
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
        path: '/reviewResult/:id',
        key: "reviewResult",
        component: ReviewResultPage,
    },
    {
        path: '/news',
        key: "news",
        component: FullNewsPage,
    },
    {
        path: '/pay',
        key: "pay",
        component: PayPage,
    },
    {
        path: '/payment',
        key: "payment",
        component: PaymentPage,
    },
    {
        path: '/paymentSuccess',
        key: "paymentSuccess",
        component: PaymentSuccessPage,
    },
    {
        path: '/registeredUsers',
        key: "registeredUsers",
        component: RegisteredUsersPage,
    },
    {
        path: '/achieves',
        key: "achieves",
        component: AchievesPage,
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
