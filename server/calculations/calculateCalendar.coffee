import Calendar from '../models/calendar'
import Submit from '../models/submit'

import logger from '../log'

export default calculateCalendar = (user) ->
    logger.info "updating calendar for user ", user
    submits = await Submit.findByUser(user)
    events = {}
    submits.forEach (submit) ->
        t = submit.time
        month = t.getMonth() + 1
        day = t.getDate()
        year = t.getFullYear()
        short = "#{year}-#{month}-#{day}"
        events[short] = if short of events then events[short] + 1 else 1
    calendar = new Calendar {_id: user, user, byDay : {submits: events}}
    await calendar.upsert()
    logger.info "updated calendar for user ", user
