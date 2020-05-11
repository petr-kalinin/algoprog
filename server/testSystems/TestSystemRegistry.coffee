import Informatics from './Informatics'
import Ejudge from './Ejudge'

export REGISTRY = 
    "informatics": new Informatics()
    "ejudge": new Ejudge('http://ejudge.algoprog.ru', 1)

export default getTestSystem = (id) ->
    REGISTRY[id]
