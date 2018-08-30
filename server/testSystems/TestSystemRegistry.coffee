#import Informatics from './Informatics'
import Ejudge from './Ejudge'

export REGISTRY = 
    "ejudge": new Ejudge('http://ejudge.algoprog.ru')

export default getTestSystem = (id) ->
    REGISTRY[id]
