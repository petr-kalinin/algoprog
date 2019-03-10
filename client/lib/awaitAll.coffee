export default awaitAll = (promises) ->
    error = undefined
    tryPromise = (p) ->
        try
            await Promise.resolve(p)
        catch e
            error = e

    results = await Promise.all(promises.map(tryPromise))
    if error
        throw error
    return results