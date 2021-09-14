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

BASE_ROUTES = [
    {
        path: '/userBadge/:id',
        component: UserBadgePage,
    },
    {
        path: '/user/:id',
        component: FullUserPage,
    },
    {
        path: '/edituser/:id',
        component: EditUserPage,
    },
    {
        path: '/table/:userList/:id',
        component: TablePage
    },
    {
        path: '/dashboard',
        component: DashboardPage,
    },
    {
        path: '/checkins',
        component: CheckinsPage,
    },
    {
        path: '/review',
        component: ReviewPage,
    },
    {
        path: '/approveFindMistake',
        component: ApproveFindMistakePage,
    },
    {
        path: '/solvedByWeek/:userList',
        component: SolvedByWeekPage,
    },
    {
        path: '/material/:id',
        component: MaterialPage,
    },
    {
        path: '/submit/:id',
        component: SubmitPage,
    },
    {
        path: '/reviewResult/:id',
        component: ReviewResultPage,
    },
    {
        path: '/findMistake/:id',
        component: FindMistakePage,
    },
    {
        path: '/findMistakeProblem/:problemId',
        component: FindMistakeProblemListPage,
    },
    {
        path: '/findMistakeList',
        component: FindMistakeListPage,
    },
    {
        path: '/news',
        component: FullNewsPage,
    },
    {
        path: '/pay',
        component: PayPage,
    },
    {
        path: '/payment',
        component: PaymentPage,
    },
    {
        path: '/paymentSuccess',
        component: PaymentSuccessPage,
    },
    {
        path: '/registeredUsers',
        component: RegisteredUsersPage,
    },
    {
        path: '/achieves',
        component: AchievesPage,
    },
    {
        path: '/comments',
        component: AllCommentsPage,
    },
    {
        path: '/usersWithAchieve/:achieve',
        component: UsersWithAchievePage,
    },
    {
        path: '/login',
        component: LoginPage,
    },
    {
        path: '/register',
        component: RegisterPage,
    },
    {
        path: '/stud',
        component: RootPage,
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