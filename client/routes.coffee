React = require('react')
import {
  BrowserRouter as Router,
  Route,
  Switch,
  Redirect
} from 'react-router-dom'

import AchievesPage from './pages/AchievesPage'
import AllCommentsPage from './pages/AllCommentsPage'
import ApproveFindMistakePage from './pages/ApproveFindMistakePage'
import CheckinsPage from './pages/CheckinsPage'
import DashboardPage from './pages/DashboardPage'
import EditUserPage from './pages/EditUserPage'
import FindMistakeListPage from './pages/FindMistakeListPage'
import FindMistakeProblemListPage from './pages/FindMistakeProblemListPage'
import FindMistakePage from './pages/FindMistakePage'
import FullNewsPage from './pages/FullNewsPage'
import FullUserPage from './pages/FullUserPage'
import LoginPage from './pages/LoginPage'
import MaterialPage from './pages/MaterialPage'
import PaymentPage from './pages/PaymentPage'
import PaymentSuccessPage from './pages/PaymentSuccessPage'
import RegisterPage from './pages/RegisterPage'
import RegisteredUsersPage from './pages/RegisteredUsersPage'
import ReviewPage from './pages/ReviewPage'
import ReviewResultPage from './pages/ReviewResultPage'
import RootPage from './pages/RootPage'
import SolvedByWeekPage from './pages/SolvedByWeekPage'
import SubmitPage from './pages/SubmitPage'
import TablePage from './pages/TablePage'
import UserBadgePage from './pages/UserBadgePage'
import UsersWithAchievePage from './pages/UsersWithAchievePage'

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
        path: '/edituser/:id',
        key: "edituser",
        component: EditUserPage,
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
        path: '/approveFindMistake',
        key: "approveFindMistake",
        component: ApproveFindMistakePage,
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
        path: '/findMistake/:id',
        key: "findMistake",
        component: FindMistakePage,
    },
    {
        path: '/findMistakeProblem/:problemId',
        key: "findMistakeProblem",
        component: FindMistakeProblemListPage,
    },
    {
        path: '/findMistakeList',
        key: "findMistakeList",
        component: FindMistakeListPage,
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
        path: '/comments',
        key: "comments",
        component: AllCommentsPage,
    },
    {
        path: '/usersWithAchieve/:achieve',
        key: "usersWithAchieve",
        component: UsersWithAchievePage,
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
