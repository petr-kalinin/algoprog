import callApi from '../lib/callApi'

export GET_DATA = 'GET_DATA'
export SAVE_DATA_PROMISES = 'SAVE_DATA_PROMISES'
export LOGOUT = 'LOGOUT'

export getData = (url, force) ->
    return
        type: GET_DATA
        payload: callApi url
        meta:
            url: url

getDataWrapper = (url) -> (args...) ->
    return getData(url, args...)

export getMe = getDataWrapper('me')

export getMyUser = getDataWrapper('myUser')

export getTree = getDataWrapper('material/tree')

export getNews = getDataWrapper('material/news')

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
