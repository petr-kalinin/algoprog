websocketsSet = {};

export subscribeWsSet = (key) ->
  websocketsSet[key] = 1

export unsubscribeWsSet = (key) ->
  delete websocketsSet[key]

export hasWsSetKey = (key) ->
  websocketsSet[key]?