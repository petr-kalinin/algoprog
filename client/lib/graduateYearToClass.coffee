MS_PER_YEAR = 1000 * 60 * 60 * 24 * 365.25

export getCurrentYearStart = () ->
    baseDate = new Date(1990, 6, 1)
    now = new Date()
    baseTime = now - baseDate
    baseYears = Math.floor(baseTime / MS_PER_YEAR)
    currentYearStart = baseDate.getTime() + baseYears * MS_PER_YEAR
    return new Date(currentYearStart).getFullYear()

export getClassStartingFromJuly = (year) -> return getClass(new Date(year, 6, 1))

export getGraduateYear = (cl) ->
    if not cl
        return null
    yearStart = getCurrentYearStart()
    yearStartDate = new Date(yearStart, 6, 1)
    graduateDate = yearStartDate.getTime() + (12 - cl) * MS_PER_YEAR
    return new Date(graduateDate).getFullYear()

export default getClass = (graduateDate) ->
    now = new Date()
    time = graduateDate - now
    if time < 0
        return null
    else
        return 11 - Math.floor(time / MS_PER_YEAR)