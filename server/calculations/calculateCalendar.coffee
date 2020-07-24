import Calendar from '../models/Calendar'
import Submit from '../models/submit'

import logger from '../log'

export default calculateCalendar = (user) ->
    logger.info "updating calendar for user ", user
    submits = await Submit.findByUser(user)
    events = {}
    previousYear = (new Date()).getFullYear() - 1
    for submit in submits
        t = submit.time
        # https://stackoverflow.com/questions/2013255/how-to-get-year-month-day-from-a-date-object
        month = t.getMonth() + 1
        day = t.getDate()
        year = t.getFullYear()
        short = "#{year}-#{month}-#{day}"
        if year >= previousYear
            events[short] = if short of events then events[short] + 1 else 1
    calendar = new Calendar {_id: user, byDay : events}
    await calendar.upsert()
    logger.info "updated calendar for user ", user
