React = require('react')
ReactDOM = require('react-dom')
Router = require('react-router').Router
Route = require('react-router').Route
Redirect = require('react-router').Redirect

import UserBadge from './components/UserBadge.coffee'

NoMatch = React.createClass
    render: () ->
        return <h2>No match for the route</h2>

ReactDOM.render(
    <Router>
        <Route path="/userBadge/:id" component={UserBadge} />
        <Redirect from="/" to="/home" />
        <Route path="*" component={NoMatch} />
    </Router>,
    document.getElementById('main')
)
