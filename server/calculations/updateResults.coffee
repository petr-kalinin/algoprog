import Table from '../models/table'
import Result from '../models/result'
import Submit from '../models/submit'

updateResultsForTable = (userId, tableId, dirtyResults) ->
    if dirtyResults and (not ((userId + "::" + tableId) of dirtyResults))
        result = await Result.findByUserAndTable(userId, tableId)
        if result
            return result
    total = 0
    solved = 0
    ok = 0
    attempts = 0
    lastSubmitId = undefined
    lastSubmitTime = undefined
    
    processRes = (res) ->
        total += res.total
        solved += res.solved
        ok += res.ok
        attempts += res.attempts
        if (!lastSubmitId) or (res.lastSubmitId and res.lastSubmitTime > lastSubmitTime)
            lastSubmitId = res.lastSubmitId
            lastSubmitTime = res.lastSubmitTime
    
    table = await Table.findById(tableId)
    console.log "table=", table
    for child in table.tables
        res = await updateResultsForTable(userId, child, dirtyResults)
        processRes(res)
    for prob in table.problems
        res = await updateResultsForProblem(userId, prob, dirtyResults)
        processRes(res)
        
    console.log "updated result ", userId, tableId, total, solved, ok, attempts, lastSubmitTime
    result = new Result(
        user: userId, 
        table: tableId, 
        total: total, 
        solved: solved, 
        ok: ok, 
        attempts: attempts, 
        lastSubmitId: lastSubmitId, 
        lastSubmitTime: lastSubmitTime
    )
    await result.upsert()
    return result

updateResultsForProblem = (userId, problemId, dirtyResults) ->
    if dirtyResults and (not ((userId + "::" + problemId) of dirtyResults))
        result = await Result.findByUserAndTable(userId, problemId)
        if result
            return result
    submits = await Submit.findByUserAndProblem(userId, problemId)
    solved = 0
    ok = 0
    attempts = 0
    ignored = 0
    lastSubmitId = undefined
    lastSubmitTime = undefined
    for submit in submits
        lastSubmitId = submit._id
        lastSubmitTime = submit.time
        if submit.outcome == "IG"
            ignored = 1
            ok = 0
            continue
        # any other result resets ignored flag
        ignored = 0
        if submit.outcome == "DQ"
            ignored = Result.DQconst
            solved = -2
            ok = 0
            break
        else if submit.outcome == "AC"
            solved = 1
            ok = 0
            break
        else if submit.outcome == "OK"
            ok = 1
            continue  # we might have a future AC
        else  if submit.outcome != "CE"
            attempts++
    console.log "updated result ", userId, problemId, solved, ok, attempts, ignored, lastSubmitId
    result = new Result
        user: userId,
        table: problemId,
        total: 1, 
        solved: solved, 
        ok: ok, 
        attempts: attempts, 
        ignored: ignored, 
        lastSubmitId: lastSubmitId, 
        lastSubmitTime: lastSubmitTime
    await result.upsert()
    return result

export default updateResults = (user, dirtyResults) ->
    console.log "updating results for user ", user
    updateResultsForTable(user, Table.main, dirtyResults)
    
