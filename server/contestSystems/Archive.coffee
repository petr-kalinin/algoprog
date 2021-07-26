export default class Archive
    makeProblemResult: (submits) ->
        ok = 0
        for submit in submits
            if submit.outcome in ["AC", "OK"]
                ok = 1
        return {ok: ok}

    makeContestResult: (problemResults) ->
        ok = 0
        attempts = 0
        for result in problemResults
            if result
                ok += result.contestResult.ok
                attempts += result.attempts
        return {ok, attempts}

    getBlockedData: () -> 
        null