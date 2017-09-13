import callApi from '../lib/callApi'

export GET_ME = 'GET_ME'
export GET_DATA = 'GET_DATA'
export SAVE_DATA_PROMISES = 'SAVE_DATA_PROMISES'

export getMe = () ->
    return
        type: GET_ME
        payload: callApi 'me'

export getData = (url) ->
    return
        type: GET_DATA
        payload: callApi url
        meta:
            url: url

export saveDataPromises = (promises) ->
    return
        type: SAVE_DATA_PROMISES
        payload:
            dataPromises: promises
