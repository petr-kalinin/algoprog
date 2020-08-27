export DISTANCE_THRESHOLD = 15
MAX_LENGTH = 3000

export distance = (s1, s2) ->
    if (not s1) or (not s2)
        return DISTANCE_THRESHOLD + 1
    if s1.length > MAX_LENGTH or s2.length > MAX_LENGTH
        return DISTANCE_THRESHOLD + 1
    d = new Array(s1.length + 1)
    for _, i in d
        d[i] = new Array(s2.length + 1)
    d[0][0] = 0
    for _, i in s1
        d[i+1][0] = i+1
    for _, j in s2
        d[0][j+1] = j+1
    for c1, i in s1
        for c2, j in s2
            d[i+1][j+1] = Math.min(d[i][j+1], d[i+1][j]) + 1
            cost = if c1 == c2 then 0 else 1
            d[i+1][j+1] = Math.min(d[i+1][j+1], d[i][j] + cost)
    return d[s1.length][s2.length]
