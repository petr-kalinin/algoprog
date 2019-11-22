crypto = require('crypto')

export MAX_LENGTH = 100000
export NO_HASH = -1
export WINDOWS = [15, 25]
export MAX_HASHES_FOR_WINDOW = 3

isIdentifier = (ch) ->
    return (ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z') or (ch >= '0' and ch <= '9') or (ch == "_")

isSpace = (ch) ->
    return ch == ' ' or ch == "\n" or ch == "\r" or ch == "\t"

tokenize = (source) ->
    result = []
    cur = ''
    curIdentifier = null
    for ch in source.split('')
        if curIdentifier? and (curIdentifier != isIdentifier(ch))
            if cur.length
                result.push(cur)
            cur = ''
        if not isSpace(ch)
            cur += ch
        curIdentifier = isIdentifier(ch)
    if cur.length
        result.push(cur)
    return result

dummyPreprocessor = (tokens) -> tokens

inOrderPreprocessor = (tokens) ->
    result = []
    m = {}
    count = 0
    for token in tokens
        if not (token of m)
            m[token] = count
            count++
        result.push(m[token])
    return result

frequencyPreprocessor = (tokens) ->
    freq = {}
    for token in tokens
        if not (token of freq)
            freq[token] = 0
        freq[token]++
    return tokens.map((token) -> freq[token])

getHash = (tokens) ->
    str = tokens.join(' ')
    return crypto.createHash('md5').update(str).digest('hex');

selectHashesAfterPreprocess = (tokens) ->
    result = []
    for window in WINDOWS
        hashes = []
        cur = []
        for i in [0...tokens.length]
            cur.push(tokens[i])
            if cur.length == window
                hashes.push(getHash(cur))
                cur.splice(0, 1)
        hashes.sort()
        for h in hashes[...MAX_HASHES_FOR_WINDOW]
            result.push
                window: window
                hash: h
    return result

export default calculateHashes = (source) ->
    if source.length > MAX_LENGTH
        return ( {window: w, hash: NO_HASH} for w in WINDOWS)
    tokens = tokenize(source)
    hashes = []
    for preprocessor in [dummyPreprocessor, inOrderPreprocessor, frequencyPreprocessor]
        p = preprocessor(tokens)
        hashes = hashes.concat(selectHashesAfterPreprocess(p))
    return hashes

