React = require('react')
import {
  BrowserRouter as Router,
  Route,
  Link,
  Switch,
  Redirect
} from 'react-router-dom'

import UserBadge from './components/UserBadge'

class NoMatch extends React.Component 
    render: () ->
        return <h2>404 Not found</h2>

export default  (
    <Switch>
        <Route path="/userBadge/:id" component={UserBadge} />
        <Route component={NoMatch}/>
    </Switch>
)

