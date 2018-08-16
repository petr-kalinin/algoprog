import Informatics from './Informatics'

export REGISTRY = 
    "informatics": new Informatics()

export default getTestSystem = (id) ->
    REGISTRY[id]
