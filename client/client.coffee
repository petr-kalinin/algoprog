import "babel-polyfill"

React = require('react')

import { BrowserRouter, Route, Link, Switch} from 'react-router-dom'

ReactDOM = require('react-dom')

import Routes from './routes.coffee'

ReactDOM.render(
    <BrowserRouter>
        <Switch>
            {Routes.map((route) => `<Route {...route} data={window.__INITIAL_STATE__}/>`)}
        </Switch>
    </BrowserRouter>,
    document.getElementById('main')
)
