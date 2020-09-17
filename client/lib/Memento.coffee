memento = {};

export subscribeMemento = (key) ->
  memento[key] = 1

export unsubscribeMemento = (key) ->
  delete memento[key]

export hasMementoKey = (key) ->
  memento[key]?