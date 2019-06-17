
MS_PER_YEAR = 1000 * 60 * 60 * 24 * 365.25

export default getClass = (graduateDate) ->
    now = new Date()
    time = graduateDate - now
    if time < 0
        return null
    else
        return 11 - Math.floor(time / MS_PER_YEAR)