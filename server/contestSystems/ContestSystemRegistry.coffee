import needRegistration from './lib/needRegistration'
import virtual from './lib/virtual'
import withLength from './lib/withLength'

import Archive from './Archive'
import Acm from './Acm'

AcmVirtual = virtual(Acm)

export REGISTRY = 
    "acm": new AcmVirtual()
    "archive": new Archive()

export default getContestSystem = (id) ->
    REGISTRY[id]
