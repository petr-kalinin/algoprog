import needRegistration from './lib/needRegistration'

import Archive from './Archive'

ArchiveWithRegistration = needRegistration(Archive)

export REGISTRY = 
    "archive": new Archive()

export default getContestSystem = (id) ->
    REGISTRY[id]
