import { combineReducers } from 'redux'
import { PENDING, FULFILLED, REJECTED } from 'redux-promise-middleware'

import { GET_DATA, SAVE_DATA_PROMISES } from './actions'

MAX_DATA_ITEMS = 20

data = (state=[], action) ->
    switch action.type
        when "#{GET_DATA}_#{PENDING}"
            updateTime = if window? then new Date() else undefined
            return state.map (data) ->
                if data.url == action.meta.url
                    return {data..., updateTime}
                else
                    return data
        when "#{GET_DATA}_#{FULFILLED}"
            updateTime = if window? then new Date() else undefined
            a = [{data: action.payload, url: action.meta.url, updateTime}]
            b = (x for x in state when x.url != action.meta.url)
            result = a.concat(b)
            if result.length > MAX_DATA_ITEMS
                result.pop()
            return result
        else
            return state

dataPromises = (state=[], action) ->
    if action.type == SAVE_DATA_PROMISES
        return state.concat(action.payload.dataPromises)
    else
        return state


export default rootReducer =
    combineReducers {
        data,
        dataPromises
    }
