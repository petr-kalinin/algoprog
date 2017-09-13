import "babel-polyfill"

React = require('react')

import { BrowserRouter, Route, Link, Switch } from 'react-router-dom'

ReactDOM = require('react-dom')

import { Provider } from 'react-redux'

import createStore from './redux/store'

import Routes from './routes'
import ScrollToTop from './components/ScrollToTop'
import YaMetrikaHit from './components/YaMetrikaHit'
import DefaultHelmet from './components/DefaultHelmet'

preloadedState = window.__PRELOADED_STATE__
delete window.__PRELOADED_STATE__
window.store = createStore(preloadedState)

ReactDOM.render(
    <Provider store={window.store}>
        <div>
            <DefaultHelmet/>
            <BrowserRouter>
                <ScrollToTop>
                    <YaMetrikaHit>
                        <Switch>
                            {Routes.map((route) => `<Route {...route} data={window.__INITIAL_STATE__}/>`)}
                        </Switch>
                    </YaMetrikaHit>
                </ScrollToTop>
            </BrowserRouter>
        </div>
    </Provider>,
    document.getElementById('main')
)

import observer from './mathJaxObserver'
