import callApi from '../lib/callApi'

import {getRawData} from './getters'

export GET_DATA = 'GET_DATA'
export INVALIDATE_DATA = 'INVALIDATE_DATA'
export SAVE_DATA_PROMISES = 'SAVE_DATA_PROMISES'
export LOGOUT = 'LOGOUT'
export LOGIN = 'POST_LOGIN'
export SET_UNKNOWN_WARNING_SHOWN = 'SET_UNKNOWN_WARNING_SHOWN'

export updateData = (url, minAgeToUpdate) ->
    (dispatch, getState) ->
        existingData = getRawData(getState(), url)
        existingDataTime = existingData?.updateTime
        if existingDataTime
            if not minAgeToUpdate?
                return
            # -200 to ensure that on age equal to minAgeToUpdate we re-request data
            if (new Date() - existingDataTime) < minAgeToUpdate * 1000 - 200
                return
        dispatch
            type: GET_DATA
            payload: callApi url
            meta:
                url: url

export invalidateData = (url) ->
    return
        type: invalidateData
        meta:
            url: url

export saveDataPromises = (promises) ->
    return
        type: SAVE_DATA_PROMISES
        payload:
            dataPromises: promises

export reloadMyData = () ->
    (dispatch) ->
        await Promise.all([dispatch(updateData("me", 0)), dispatch(updateData("myUser", 0))])

export logout = () ->
    (dispatch) ->
        await callApi 'logout'
        await reloadMyData()(dispatch)

export setUnknownWarningShown = () ->
    return
        type: SET_UNKNOWN_WARNING_SHOWN
