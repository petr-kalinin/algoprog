import Problem from '../models/problem'
import Table from '../models/table'

export default setDirty = (submit, dirtyResults, dirtyUsers) ->
    userId = submit.user
    probId = submit.problem
    dirtyUsers[userId] = 1
    dirtyResults[userId + "::" + probId] = 1
    problem = await Problem.findById(probId)
    if not problem
        return
    for table in problem.tables
        t = table
        while true
            t = await Table.findById(t)
            if t._id.startsWith("main")
                break
            dirtyResults[userId + "::" + t._id] = 1
            t = t.parent
    dirtyResults[userId + "::main"] = 1
