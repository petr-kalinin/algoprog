import User from '../models/user'
import Table from '../models/table'
import Result from '../models/result'
import Submit from '../models/submit'

import addTotal from '../../client/lib/addTotal'
import isContestRequired from '../../client/lib/isContestRequired'

import logger from '../log'

updateResultsForTable = (userId, tableId, dirtyResults) ->
    if dirtyResults and (not ((userId + "::" + tableId) of dirtyResults))
        _debug_marker = {qwe: '129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129_129'}
        result = await Result.findByUserAndTable(userId, tableId)
        if result
            return result

    total = {}
    _debug_marker = {qwe: '130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130_130'}
    table = await Table.findById(tableId)
    for child in table.tables
        _debug_marker = {qwe: '131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131_131'}
        res = await updateResultsForTable(userId, child, dirtyResults)
        _debug_marker = {qwe: '132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132_132'}
        fullChild = await Table.findById(child)
        if not isContestRequired(fullChild?.name)
            res.required = 0
        total = addTotal(total, res, true)
    for prob in table.problems
        _debug_marker = {qwe: '133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133_133'}
        res = await updateResultsForProblem(userId, prob, dirtyResults)
        total = addTotal(total, res, true)

    logger.debug "updated result ", userId, tableId, total
    result = new Result({
        total...,
        user: userId,
        table: tableId
    })
    _debug_marker = {qwe: '134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134_134'}
    await result.upsert()
    return result

updateResultsForProblem = (userId, problemId, dirtyResults) ->
    if dirtyResults and (not ((userId + "::" + problemId) of dirtyResults))
        _debug_marker = {qwe: '135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135_135'}
        result = await Result.findByUserAndTable(userId, problemId)
        if result
            return result
    _debug_marker = {qwe: '136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136_136'}
    submits = await Submit.findByUserAndProblem(userId, problemId)
    solved = 0
    ok = 0
    attempts = 0
    ignored = 0
    lastSubmitId = undefined
    lastSubmitTime = undefined
    for submit in submits
        if submit.outcome == "DR"
            continue
        lastSubmitId = submit._id
        lastSubmitTime = submit.time
        if submit.outcome == "IG"
            if solved == 0
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
            continue  # we might have a future OK
        else if submit.outcome == "OK"
            ok = 1
            continue  # we might have a future AC
        else if submit.outcome != "CE"
            attempts++
    logger.debug "updated result ", userId, problemId, solved, ok, attempts, ignored, lastSubmitId
    result = new Result
        user: userId,
        table: problemId,
        total: 1,
        required: 1,
        solved: solved,
        ok: ok,
        attempts: attempts,
        ignored: ignored,
        lastSubmitId: lastSubmitId,
        lastSubmitTime: lastSubmitTime
    _debug_marker = {qwe: '137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137_137'}
    await result.upsert()
    return result

export default updateResults = (user, dirtyResults) ->
    logger.info "updating results for user ", user
    _debug_marker = {qwe: '138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138_138'}
    await updateResultsForTable(user, Table.main, dirtyResults)
    logger.info "updated results for user ", user
