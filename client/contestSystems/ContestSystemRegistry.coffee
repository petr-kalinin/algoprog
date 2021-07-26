import needRegistration from './lib/needRegistration'
import virtual from './lib/virtual'

import Archive from './Archive'

ArchiveWithVirtual = virtual(Archive)
ArchiveWithRegistration = needRegistration(Archive)

export REGISTRY = 
    "archive": new ArchiveWithVirtual()

export default getContestSystem = (id) ->
    REGISTRY[id]
