import Calendar from '../models/Calendar'
import Submit from '../models/submit'

import logger from '../log'

export default calculateCalendar = (user) ->
    start = new Date()
    logger.info "updating calendar for user ", user
    submits = await Submit.findByUserWithFindMistakeAny(user)
    events = {}
    previousYear = (new Date()).getFullYear() - 1
    for submit in submits
        t = submit.time
        month = t.getMonth() + 1
        day = t.getDate()
        year = t.getFullYear()
        short = "#{year}-#{month}-#{day}"
        if year >= previousYear
            events[short] = if short of events then events[short] + 1 else 1
    calendar = new Calendar {_id: user, byDay : events}
    await calendar.upsert()
    logger.info "updated calendar for user ", user, " spent time ", (new Date()) - start
