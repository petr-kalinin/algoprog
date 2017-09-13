import { combineReducers } from 'redux'
import { PENDING, FULFILLED, REJECTED } from 'redux-promise-middleware'

import { GET_ME, GET_TREE, GET_NEWS, GET_DATA, SAVE_DATA_PROMISES } from './actions'

me = (state=null, action) ->
    switch action.type
        when "#{GET_ME}_#{FULFILLED}"
            return action.payload
        when "#{GET_ME}_#{REJECTED}"
            return null
        else
            return state

tree = (state=null, action) ->
    switch action.type
        when "#{GET_TREE}_#{FULFILLED}"
            return action.payload
        when "#{GET_TREE}_#{REJECTED}"
            return null
        else
            return state

news = (state=null, action) ->
    switch action.type
        when "#{GET_NEWS}_#{FULFILLED}"
            return action.payload
        when "#{GET_NEWS}_#{REJECTED}"
            return null
        else
            return state

data = (state={}, action) ->
    switch action.type
        when "#{GET_DATA}_#{FULFILLED}"
            return
                data: action.payload
                url: action.meta.url
        when "#{GET_DATA}_#{REJECTED}"
            return
                data: null
                url: null
        else
            return state

dataPromises = (state=[], action) ->
    if action.type == SAVE_DATA_PROMISES
        return state.concat(action.payload.dataPromises)
    else
        return state


export default rootReducer =
    combineReducers {
        me,
        tree,
        news,
        data,
        dataPromises
    }
