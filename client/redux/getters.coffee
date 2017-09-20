export getRawData = (state, url) ->
    found = (x for x in state.data when x.url == url or decodeURIComponent(x.url) == url or x.url == decodeURIComponent(url))
    if found.length > 1
        throw "Duplicate url in state.data"
    if found.length == 0
        return null
    return found[0]

export getData = (state, url) ->
    return getRawData(state, url)?.data

getDataWrapper = (url) -> (state) ->
    return getData(state, url)

export getMe = getDataWrapper('me')

export getMyUser = getDataWrapper('myUser')

export getTree = getDataWrapper('material/tree')

export getNews = getDataWrapper('material/news')
