import { combineReducers } from 'redux'
import { PENDING, FULFILLED, REJECTED } from 'redux-promise-middleware'

import {reducer as notifications} from 'react-notification-system-redux';

import { GET_DATA, INVALIDATE_DATA, INVALIDATE_ALL_DATA, SAVE_DATA_PROMISES, SET_UNKNOWN_WARNING_SHOWN, SET_UNPAID_WARNING_SHOWN, THEME_SWITCH } from './actions'

import { equalUrl } from './getters'

import Cookies from 'universal-cookie'

MAX_DATA_ITEMS = 100

data = (state=[], action) ->
    switch action.type
        when "#{GET_DATA}_#{PENDING}", "#{GET_DATA}_#{FULFILLED}", "#{GET_DATA}_#{REJECTED}"
            updateTime = if window? then new Date() else undefined
            switch action.type
                when "#{GET_DATA}_#{PENDING}"
                    newValue = (x for x in state when equalUrl(x.url, action.meta.url))[0] || {}
                    delete newValue.rejected
                    newValue.pending = true
                when "#{GET_DATA}_#{FULFILLED}"
                    newValue = {data: action.payload, success: true}
                when "#{GET_DATA}_#{REJECTED}"
                    newValue = {rejected: true}
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

unknownWarningShown = (state = false, action) ->
    if action.type == SET_UNKNOWN_WARNING_SHOWN
        return action.value
    else
        return state

unpaidWarningShown = (state = false, action) ->
    if action.type == SET_UNPAID_WARNING_SHOWN
        return action.value
    else
        return state

 defaultTheme = () ->
    cookies = new Cookies
    cookie = cookies.get('Theme')
    if not window? 
        return null
    if (cookie == "dark") || (cookie == "light")
        return cookie
    else 
        cookie = "light"
        return cookie

theme = (state = defaultTheme(), action) ->
    if state == null
        state =  defaultTheme()
    if action.type == THEME_SWITCH
        return action.value
    else
        return state

clientCookie = (state = null, action) -> state


export default rootReducer =
    combineReducers {
        data,
        dataPromises,
        unknownWarningShown,
        unpaidWarningShown,
        theme,
        notifications,
        clientCookie
    }
