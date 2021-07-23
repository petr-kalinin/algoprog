import Archive from './Archive'

export REGISTRY = 
    "archive": new Archive()

export default getContestSystem = (id) ->
    REGISTRY[id]
