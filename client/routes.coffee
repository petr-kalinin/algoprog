React = require('react')
import {
  BrowserRouter as Router,
  Route,
  Link,
  Switch,
  Redirect
} from 'react-router-dom'

import UserBadgePage from './pages/UserBadgePage'

class NoMatch extends React.Component 
    render: () ->
        return <h2>404 Not found</h2>

export default  (
    <Switch>
        <Route path="/userBadge/:id" component={UserBadgePage} />
        <Route component={NoMatch}/>
    </Switch>
)

