export default class Archive
    makeProblemResult: (submits, contestResult) ->
        startTime = contestResult.startTime || new Date(0)
        ok = 0
        for submit in submits
            if submit.outcome in ["AC", "OK"]
                ok = 1
                time = Math.floor((submit.time - startTime) / 1000 / 60)
                break
        return {ok, time}

    makeContestResult: (problemResults) ->
        ok = 0
        time = 0
        attempts = 0
        for result in problemResults
            if result
                ok += result.contestResult.ok
                if result.contestResult.ok
                    time += result.contestResult.time + result.attempts * 20
                    attempts += result.attempts
        return {ok, time, attempts}

    getBlockedData: () -> 
        null

    shouldBlockSubmit: () ->
        false

    shouldShowResult: () ->
        true

    sortMonitor: (results) ->
        results.sort( (a, b) -> 
            if a.contestResult.ok != b.contestResult.ok
                return b.contestResult.ok - a.contestResult.ok
            a.contestResult.time - b.contestResult.time
        )
        return results
