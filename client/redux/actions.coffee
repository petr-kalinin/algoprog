import callApi, {callApiWithBody, callWsApiWithBody} from '../lib/callApi'

import {getRawData} from './getters'

export GET_DATA = 'GET_DATA'
export INVALIDATE_DATA = 'INVALIDATE_DATA'
export INVALIDATE_ALL_DATA = 'INVALIDATE_ALL_DATA'
export SAVE_DATA_PROMISES = 'SAVE_DATA_PROMISES'
export LOGOUT = 'LOGOUT'
export LOGIN = 'POST_LOGIN'
export SET_DEACTIVATED_WARNING_SHOWN = 'SET_DEACTIVATED_WARNING_SHOWN'
export SET_UNPAID_WARNING_SHOWN = 'SET_UNPAID_WARNING_SHOWN'
export SWITCH_THEME = 'SWITCH_THEME'

export updateData = (url, minAgeToUpdate, cookies) ->
    (dispatch, getState) ->
        existingData = getRawData(getState(), url)
        existingDataTime = existingData?.updateTime
        if existingDataTime
            if not minAgeToUpdate?
                return
            # -200 to ensure that on age equal to minAgeToUpdate we re-request data
            if (new Date() - existingDataTime) < minAgeToUpdate - 200
                return
        dispatch
            type: GET_DATA
            payload: callApiWithBody url, 'GET', if cookies then {"Cookie": cookies} else {}
            meta:
                url: url

export updateWsData = (url) ->
    (dispatch, getState) ->
        callWsApiWithBody url, (result) ->
            dispatch
                type: GET_DATA
                payload: Promise.resolve(JSON.parse(result))
                meta:
                    url: url

export invalidateData = (url) ->
    return
        type: INVALIDATE_DATA
        meta:
            url: url

export saveDataPromises = (promises) ->
    return
        type: SAVE_DATA_PROMISES
        payload:
            dataPromises: promises

export invalidateAllData = () ->
    return
        type: INVALIDATE_ALL_DATA

export logout = () ->
    (dispatch) ->
        await callApi 'logout'
        dispatch(invalidateAllData())

export setDeactivatedWarningShown = (value=true) ->
    return
        type: SET_DEACTIVATED_WARNING_SHOWN
        value: value

export setUnpaidWarningShown = (value=true) ->
    return
        type: SET_UNPAID_WARNING_SHOWN
        value: value
        
export switchTheme = (newTheme) ->
    return 
        type: SWITCH_THEME
        value: newTheme
