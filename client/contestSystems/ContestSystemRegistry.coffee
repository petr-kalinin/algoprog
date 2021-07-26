import needRegistration from './lib/needRegistration'
import virtual from './lib/virtual'

import Archive from './Archive'
import Acm from './Acm'

AcmWithVirtual = virtual(Acm)
ArchiveWithRegistration = needRegistration(Archive)

export REGISTRY = 
    "acm": new AcmWithVirtual()
    "archive": new Archive()

export default getContestSystem = (id) ->
    REGISTRY[id]
