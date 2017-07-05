export default parseLevel = (level) ->
    if level.substr(0,3) == "reg"
        if level.length == 3
            res = { major: "reg" }
        else
            res = { major: "reg", minor: level.substr(3) }
        return res
    last = level.slice(-1)
    if (last >= '0') and (last <= '9')
        res = { major : level }
    else 
        res = { major : level.slice(0, -1), minor : last }
    console.log "level ", level, " parsed ", res
    res
