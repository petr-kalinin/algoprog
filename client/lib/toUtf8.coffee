iconv = require('iconv-lite')

export default toUtf8 = (sourceRaw) ->
    iconv.decode(Buffer.from(sourceRaw, "latin1"), "utf8")
