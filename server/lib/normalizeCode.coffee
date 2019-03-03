export default normalizeCode = (string) ->
    # Informatics trims spaces in source, at least at the beginning
    string = string.trim()
    # normalize end-of-lines, including mixed ones
    string = string.replace(/\r\n/g, "\n")
    return string.replace(/\n/g, "\r\n")