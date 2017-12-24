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

export reloadMyData = () ->
    (dispatch) ->
        await Promise.all([dispatch(getData("me", true)), dispatch(getData("myUser", true))])

export logout = () ->
    (dispatch) ->
        await callApi 'logout'
        await reloadMyData()(dispatch)

export setUnknownWarningShown = () ->
    return
        type: SET_UNKNOWN_WARNING_SHOWN
