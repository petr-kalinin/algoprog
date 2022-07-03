MS_PER_YEAR = 1000 * 60 * 60 * 24 * 365.25

export getCurrentYearStart = () ->
    baseDate = new Date(1990, 6, 1)
    now = new Date()
    baseTime = now - baseDate
    baseYears = Math.floor(baseTime / MS_PER_YEAR)
    currentYearStart = baseDate.getTime() + baseYears * MS_PER_YEAR
    return new Date(currentYearStart).getFullYear()

export getClassStartingFromJuly = (year) -> return getClass(new Date(year, 6, 1))

export getYear = (clas) ->
    now = new Date()
    return (11-clas+now.getFullYear() + Math.floor((6 + now.getMonth())/12))

export default getClass = (graduateDate) ->
    now = new Date()
    time = graduateDate - now
    if time < 0
        return null
    else
        return 11 - Math.floor(time / MS_PER_YEAR)