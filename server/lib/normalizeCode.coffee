export default normalizeCode = (string) ->
    string = string.trim()
    if string.includes("\r\n")
        return string
    return string.replace(/\n/g, "\r\n")