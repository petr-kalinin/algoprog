import { createStore, applyMiddleware } from 'redux'
import promiseMiddleware from 'redux-promise-middleware'
import ReduxThunk from 'redux-thunk'

import rootReducer from './reducers'

export default createMyStore = (state) ->
    createStore(rootReducer, state, applyMiddleware(promiseMiddleware(), ReduxThunk))
