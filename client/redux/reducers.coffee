import { combineReducers } from 'redux'
import { ActionType } from 'redux-promise-middleware'

import {reducer as notifications} from 'react-notification-system-redux';

import { GET_DATA, INVALIDATE_DATA, INVALIDATE_ALL_DATA, SAVE_DATA_PROMISES, SET_DEACTIVATED_WARNING_SHOWN, SET_UNPAID_WARNING_SHOWN, SWITCH_THEME } from './actions'

import { equalUrl } from './getters'

MAX_DATA_ITEMS = 100

data = (state=[], action) ->
    switch action.type
        when "#{GET_DATA}_#{ActionType.Pending}", "#{GET_DATA}_#{ActionType.Fulfilled}", "#{GET_DATA}_#{ActionType.Rejected}"
            updateTime = if window? then new Date() else undefined
            switch action.type
                when "#{GET_DATA}_#{ActionType.Pending}"
                    newValue = (x for x in state when equalUrl(x.url, action.meta.url))[0] || {}
                    delete newValue.rejected
                    newValue.pending = true
                when "#{GET_DATA}_#{ActionType.Fulfilled}"
                    newValue = {data: action.payload}
                when "#{GET_DATA}_#{ActionType.Rejected}"
                    newValue = (x for x in state when equalUrl(x.url, action.meta.url))[0] || {}
                    delete newValue.pending
                    newValue.rejected = true
            a = [{newValue..., url: action.meta.url, updateTime}]
            b = (x for x in state when !equalUrl(x.url, action.meta.url))
            result = a.concat(b)
            if result.length > MAX_DATA_ITEMS
                result.pop()
            return result
        when INVALIDATE_DATA
            result = (x for x in state when not equalUrl(x.url, action.meta.url))
            return result
        when INVALIDATE_ALL_DATA
            return []
        else
            return state

dataPromises = (state=[], action) ->
    if action.type == SAVE_DATA_PROMISES
        return state.concat(action.payload.dataPromises)
    else
        return state

deactivatedWarningShown = (state = false, action) ->
    if action.type == SET_DEACTIVATED_WARNING_SHOWN
        return action.value
    else
        return state

unpaidWarningShown = (state = false, action) ->
    if action.type == SET_UNPAID_WARNING_SHOWN
        return action.value
    else
        return state

theme = (state = null , action) ->
    if action.type == SWITCH_THEME
        return action.value
    else
        return state

clientCookie = (state = null, action) -> state

needDataPromises = (state = null, action) -> state

export default rootReducer =
    combineReducers {
        data,
        dataPromises,
        deactivatedWarningShown,
        unpaidWarningShown,
        theme,
        notifications,
        clientCookie,
        needDataPromises
    }
