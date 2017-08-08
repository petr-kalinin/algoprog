accountAttempts = (result) ->
    if result.solved or result.ok
        result.attempts
    else
        0

export default addTotal = (a, b) ->
    if not a
        return b
    else if not b
        return a
    return
        solved: a.solved + b.solved
        ok: a.ok + b.ok
        ignored: a.ignored + b.ignored
        attempts: accountAttempts(a) + accountAttempts(b)
        total: a.total + b.total

