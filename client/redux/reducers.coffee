import { combineReducers } from 'redux'
import { PENDING, FULFILLED, REJECTED } from 'redux-promise-middleware'

import { GET_ME, GET_FULL_USER, SAVE_DATA_PROMISES } from './actions'

me = (state=null, action) ->
    switch action.type
        when "#{GET_ME}_#{FULFILLED}"
            return action.payload
        when "#{GET_ME}_#{REJECTED}"
            return null
        else
            return state

users = (state={}, action) ->
    switch action.type
        when "#{GET_FULL_USER}_#{FULFILLED}"
            return  {state..., "#{action.meta._id}": action.payload}
        when "#{GET_FULL_USER}_#{REJECTED}"
            return {state..., "#{action.meta._id}": null}
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
        users
        dataPromises
    }
