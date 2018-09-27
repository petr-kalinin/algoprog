#import Informatics from './Informatics'
import Ejudge from './Ejudge'

export REGISTRY = 
    "ejudge": new Ejudge('http://ejudge.algoprog.ru', 2)

export default getTestSystem = (id) ->
    REGISTRY[id]
