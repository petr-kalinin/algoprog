scheme2cb = {}

export addCallback = (schemeName, cbName, cb) ->
    scheme2cb[schemeName][cbName] = cb
    cb()

export addHook = (schemeName) ->
    scheme2cb[schemeName] = {}
    () ->
        for k of scheme2cb[schemeName]
            try
                scheme2cb[schemeName][k]()
            catch e
                delete scheme2cb[schemeName][k]