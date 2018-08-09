import Informatics from './Informatics'

REGISTRY = 
    "informatics": new Informatics()

export default getTestSystem = (id) ->
    REGISTRY[id]