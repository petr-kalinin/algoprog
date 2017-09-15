import callApi from '../lib/callApi'

export GET_ME = 'GET_ME'
export GET_MY_USER = 'GET_MY_USER'
export GET_TREE = 'GET_TREE'
export GET_NEWS = 'GET_NEWS'
export GET_DATA = 'GET_DATA'
export SAVE_DATA_PROMISES = 'SAVE_DATA_PROMISES'

export getMe = () ->
    return
        type: GET_ME
        payload: callApi 'me'

export getMyUser = () ->
    return
        type: GET_MY_USER
        payload: callApi 'myUser'

export getTree = () ->
    return
        type: GET_TREE
        payload: callApi 'material/tree'

export getNews = () ->
    return
        type: GET_NEWS
        payload: callApi 'material/news'

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
