import callApi from '../lib/callApi'

export GET_ME = 'GET_ME'
export GET_FULL_USER = 'GET_FULL_USER'
export SAVE_DATA_PROMISES = 'SAVE_DATA_PROMISES'

export getMe = () ->
    return
        type: GET_ME
        payload: callApi 'me'

export getFullUser = (id) ->
    return
        type: GET_FULL_USER
        payload: callApi 'fullUser/' + id
        meta:
            _id: id

export saveDataPromises = (promises) ->
    return
        type: SAVE_DATA_PROMISES
        payload:
            dataPromises: promises
