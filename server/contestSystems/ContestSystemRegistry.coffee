import needRegistration from './lib/needRegistration'
import virtual from './lib/virtual'
import withLength from './lib/withLength'

import Archive from './Archive'

ArchiveWithRegistration = needRegistration(Archive)
ArchiveVirtual = withLength(virtual(Archive))

export REGISTRY = 
    "archive": new Archive()

export default getContestSystem = (id) ->
    REGISTRY[id]
