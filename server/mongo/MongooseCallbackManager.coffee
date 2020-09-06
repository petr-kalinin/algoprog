scheme2cb = {}

getRandomString = (length) =>
    Math.random().toString(36).substring(2, length + 2)

export addMongooseCallback = (schemeName, user, cb) ->
    cbName = getRandomString(5)
    if not scheme2cb[schemeName]? then scheme2cb[schemeName] = {}
    if not scheme2cb[schemeName][user]? then scheme2cb[schemeName][user] = {}
    scheme2cb[schemeName][user][cbName] = cb
    cb()

export runMongooseCallback = (schemeName, user) ->
    for k of scheme2cb?[schemeName]?[user]
        try
            scheme2cb[schemeName][user][k]()
        catch e
            delete scheme2cb[schemeName][user][k]