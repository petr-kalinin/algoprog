import callApi from '../lib/callApi'

import {getRawData as getRawDataGetter} from './getters'

export GET_DATA = 'GET_DATA'
export SAVE_DATA_PROMISES = 'SAVE_DATA_PROMISES'
export LOGOUT = 'LOGOUT'
export LOGIN = 'POST_LOGIN'
export SET_UNKNOWN_WARNING_SHOWN = 'SET_UNKNOWN_WARNING_SHOWN'

export getData = (url, force) ->
    (dispatch, getState) ->
        existingData = getRawDataGetter(getState(), url)
        if not force and existingData?.updateTime
            return
        dispatch
            type: GET_DATA
            payload: callApi url
            meta:
                url: url

getDataWrapper = (url) -> (args...) ->
    return getData(url, args...)

export saveDataPromises = (promises) ->
    return
        type: SAVE_DATA_PROMISES
        payload:
            dataPromises: promises

doLogout = (dispatch) ->
    await callApi 'logout'
    await Promise.all([dispatch(getMe(true)), dispatch(getMyUser(true))])

export logout = (dispatch) ->
    return
        type: LOGOUT
        payload: doLogout dispatch

export postLogin = () ->
    (dispatch) ->
        await Promise.all([dispatch(getMe(true)), dispatch(getMyUser(true))])

export setUnknownWarningShown = () ->
    return
        type: SET_UNKNOWN_WARNING_SHOWN
