import Codeforces from './Codeforces'
import Ejudge from './Ejudge'
import Informatics from './Informatics'

export REGISTRY = 
    "informatics": new Informatics()
    "ejudge": new Ejudge('https://ejudge.algoprog.ru', 2000),
    "codeforces": new Codeforces()

export default getTestSystem = (id) ->
    REGISTRY[id]
