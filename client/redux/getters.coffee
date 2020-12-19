export equalUrl = (url1, url2) ->
    url1 == url2 or decodeURIComponent(url1) == url2 or url1 == decodeURIComponent(url2)

export getRawData = (state, url) ->
    found = (x for x in state.data when equalUrl(url, x.url))
    if found.length > 1
        throw "Duplicate url #{url} in state.data "
    if found.length == 0
        return null
    return found[0]

export hasData = (state, url) ->
    return getRawData(state, url)?.data

export isDataRejected = (state, url) ->
    d = getRawData(state, url)
    return d?.rejected and (not d?.data)

export getData = (state, url) ->
    return getRawData(state, url)?.data
