React = require('react')
import {
  BrowserRouter as Router,
  Route,
  Link,
  Switch,
  Redirect
} from 'react-router-dom'

import UserBadgePage from './pages/UserBadgePage'
import DashboardPage from './pages/DashboardPage'
import Login from './components/Login'
import Register from './components/Register'
import TablePage from './pages/TablePage'

class NoMatch extends React.Component 
    render: () ->
        return <h2>404 Not found</h2>

export default [
    { 
        path: '/userBadge/:id',
        key: "userBadge",
        component: UserBadgePage,
        loadData: UserBadgePage.loadData,
    },
    { 
        path: '/user/:id',
        key: "user",
        component: UserBadgePage,
        loadData: UserBadgePage.loadData,
    },
    { 
        path: '/table/:userList/:id',
        key: "table",
        component: TablePage
        loadData: TablePage.loadData,
    },
    { 
        path: '/dashboard',
        key: "dashboard",
        component: DashboardPage,
        loadData: DashboardPage.loadData,
    },
    { 
        path: '/login',
        key: "login",
        component: Login,
    },
    { 
        path: '/register',
        key: "register",
        component: Register,
    },
    { 
        component: NoMatch,
        key: "nomatch"
    },
]
  
