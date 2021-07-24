import needRegistration from './lib/needRegistration'
import virtual from './lib/virtual'

import Archive from './Archive'

ArchiveWithVirtual = virtual(Archive)

export REGISTRY = 
    "archive": new Archive()

export default getContestSystem = (id) ->
    REGISTRY[id]
