export default uinx2dox = (string) ->
    if string.includes("\r\n")
        return string
    return string.replace(/\n/g, "\r\n")