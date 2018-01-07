accountAttempts = (result, countUnsolvedAttempts) ->
    if countUnsolvedAttempts or result?.solved or result?.ok
        result?.attempts || 0
    else
        0

export default addTotal = (a, b, countUnsolvedAttempts = false) ->
    SIMPLE_KEYS = ["total", "required", "solved", "ok", "ignored"]

    result = {}
    for key in SIMPLE_KEYS
        result[key] = (a?[key] || 0) + (b?[key] || 0)
    result.attempts = accountAttempts(a, countUnsolvedAttempts) + accountAttempts(b, countUnsolvedAttempts)
    result.lastSubmitId = a?.lastSubmitId
    result.lastSubmitTime = a?.lastSubmitTime

    if (!a?.lastSubmitId) or (b?.lastSubmitId and b.lastSubmitTime > a.lastSubmitTime)
        result.lastSubmitId = b?.lastSubmitId
        result.lastSubmitTime = b?.lastSubmitTime

    return result
