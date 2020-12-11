request = require('request-promise-native')
import CfResult from '../models/cfResult'
import logger from '../log'

colors = [[0, "gray"], [1200, "green"], [1400, "#03A89E"], [1600, "blue"],
         [1900, "#a0a"], [2100, "#FF8C00"], [2400, "red"]];

getRating = (user) ->
    href = "https://codeforces.com/api/user.info?handles=" + user.cf.login
    text = await request href
    data = JSON.parse(text)["result"]
    return data[0]["rating"]

MSEC_IN_WEEK = 1000*60*60*24*7
EXPONENT = MSEC_IN_WEEK * 4
timeScore = (date) ->
    weeks = (new Date() - date)/EXPONENT
    return Math.pow(0.5, weeks)

getActivityAndProgress = (user) ->
    href = "https://codeforces.com/api/user.rating?handle=" + user.cf.login
    text = await request href
    logger.trace "cf returns ", text
    data = JSON.parse(text)["result"]

    startDate = new Date("2016-09-01")
    change = 0
    contests = 0
    first = true

    for elem in data
        thisDate = new Date(elem["ratingUpdateTimeSeconds"] * 1000)
        await new CfResult(
            userId: user._id,
            contestId: elem["contestId"],
            time: thisDate,
            place: elem["rank"],
            oldRating: elem["oldRating"],
            newRating: elem["newRating"]
        ).upsert()
        if (not first)  # very first contest has no meaning as start rating is 1500
            change += (elem["newRating"] - elem["oldRating"]) * timeScore(thisDate)
        contests += timeScore(thisDate)
        first = false
    return activity: contests, progress: change

colorByRating = (rating) ->
    color = ""
    for c in colors
        if c[0] > rating
            break
        color = c[1]
    return color

export default calculateCfRating = (user) ->
    if not user.cf.login
        return
    try
        rating = await getRating(user)
    catch
        return
    color = colorByRating(rating)
    activityAndProgress = await getActivityAndProgress(user)
    return
        rating: rating,
        color: color,
        activity: activityAndProgress.activity,
        progress: activityAndProgress.progress
