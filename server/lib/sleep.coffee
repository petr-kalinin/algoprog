export default sleep = (milliseconds) ->
    return new Promise((resolve) -> setTimeout(resolve, milliseconds))
