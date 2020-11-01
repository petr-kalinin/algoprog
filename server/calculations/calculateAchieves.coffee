import ACHIEVES from '../../client/lib/achieves'
import logger from '../log'

achievesConditions = (user) ->
    chocos0 = (user.chocos?[0] || 0) - 1
    fullcontests:
        30: 3 * chocos0 >= 30
        15: 3 * chocos0 >= 15
        6: 3 * chocos0 >= 6
        3: 3 * chocos0 >= 3
    clearcontests:
        7: user.chocos?[1] >= 7
        4: user.chocos?[1] >= 4
        2: user.chocos?[1] >= 2
        1: user.chocos?[1] >= 1
    plusone:
        14: 2 * user.chocos?[2] >= 14
        8: 2 * user.chocos?[2] >= 8
        4: 2 * user.chocos?[2] >= 4
        2: 2 * user.chocos?[2] >= 2
    cf:
        part: user.cf?.rating
        1500: user.cf?.rating >= 1500
        1700: user.cf?.rating >= 1700
        1900: user.cf?.rating >= 1900
    a:
        3: user.activity >= 3
        6: user.activity >= 6 and user.level.current >= "1Б"
        10: user.activity >= 10 and user.level.current >= "2"
        15: user.activity >= 15 and user.level.current >= "3"
        options:
            doNoRevoke: true

export default calculateAchieves = (user) ->
    start = new Date()
    logger.info "calculate achieves ", user._id
    result = user?.achieves || []
    conditions = achievesConditions(user)
    for prefix, c of conditions
        suffixScore = (suffix) ->
            ACHIEVES["#{prefix}:#{suffix}"]?.score

        bestSuffix = undefined
        if  c.options?.doNoRevoke
            oldAchieves = (r for r in result when (r.startsWith(prefix + ":")))
            if oldAchieves.length
                bestSuffix = oldAchieves[0].split(":")[1]
        result = (r for r in result when not (r.startsWith(prefix + ":")))
        for suffix, condition of c
            if suffix == "options"
                continue
            if not condition
                continue
            if not bestSuffix
                bestSuffix = suffix
                continue
            if suffixScore(bestSuffix) < suffixScore(suffix)
                bestSuffix = suffix
        if bestSuffix
            result.push("#{prefix}:#{bestSuffix}")
    logger.info "calculated achieves ", user._id, " spent time ", (new Date()) - start
    return result
