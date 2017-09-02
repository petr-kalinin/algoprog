import "babel-polyfill"

React = require('react')

import { BrowserRouter, Route, Link, Switch } from 'react-router-dom'

ReactDOM = require('react-dom')

import Routes from './routes'
import ScrollToTop from './components/ScrollToTop'

ReactDOM.render(
    <BrowserRouter>
        <ScrollToTop>
            <Switch>
                {Routes.map((route) => `<Route {...route} data={window.__INITIAL_STATE__}/>`)}
            </Switch>
        </ScrollToTop>
    </BrowserRouter>,
    document.getElementById('main')
)

import observer from './mathJaxObserver'
