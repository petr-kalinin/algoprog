export default awaitAll = (promises) ->
    error = undefined
    results = await Promise.all(promises.map((p) -> p.catch((e) -> error = e)))
    if error
        throw error
    return results