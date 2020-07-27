export default normalizeCode = (string) ->
    if not string
        return string
    # remove bom, see https://ejudge.ru/wiki/index.php/Serve.cfg:global:ignore_bom
    if string.startsWith("\xEF\xBB\xBF")
        string = string.substring(3)
    # Informatics trims spaces in source, at least at the beginning
    string = string.trim()
    # normalize end-of-lines, including mixed ones
    string = string.replace(/\r\n/g, "\n")
    return string.replace(/\n/g, "\r\n")
