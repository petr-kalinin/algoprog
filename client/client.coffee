import "babel-polyfill"

React = require('react')

import { BrowserRouter, Route, Link, Switch } from 'react-router-dom'

ReactDOM = require('react-dom')

import { Provider } from 'react-redux'

import createStore from './redux/store'

import Routes from './routes'
import GotoProvider from './components/GotoProvider'
import ScrollToTop from './components/ScrollToTop'
import YaMetrikaHit from './components/YaMetrikaHit'
import DefaultHelmet from './components/DefaultHelmet'
import ConnectedNotifications from './components/ConnectedNotifications'
import ThemeCss from './components/ThemeCss'

preloadedState = window.__PRELOADED_STATE__
delete window.__PRELOADED_STATE__
window.store = createStore(preloadedState)

ReactDOM.hydrate(
    <Provider store={window.store}>
        <div>
            <DefaultHelmet/>
            <ThemeCss/>
            <BrowserRouter>
                <div>
                    <ScrollToTop>
                        <YaMetrikaHit>
                            <GotoProvider>
                                <Switch>
                                    {Routes.map((route) => `<Route {...route} data={window.__INITIAL_STATE__}/>`)}
                                </Switch>
                            </GotoProvider>
                        </YaMetrikaHit>
                    </ScrollToTop>
                    <ConnectedNotifications/>
                </div>
            </BrowserRouter>
        </div>
    </Provider>,
    document.getElementById('main')
)

import observer from './mathJaxObserver'
