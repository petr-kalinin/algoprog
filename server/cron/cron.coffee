cron = require('node-cron')

import * as downloadSubmits from "./downloadSubmits"
import * as downloadBlog from './downloadBlog'
import updateCf from "./updateCf"
import submitSubmits from './submitSubmits'
import sendMetrics from './sendMetrics'

import logger from '../log'
import User from '../models/user'

offset = (new Date().getTimezoneOffset()) / 60
MOSCOW_OFFSET = -3
nightHour = (3 + MOSCOW_OFFSET - offset - 1) %% 24

logger.info "Will set updateResults to " + nightHour + ":59:58 local time"

export default scheduleJobs = () ->
    cron.schedule('*/10 * * * * *', downloadSubmits.runForCT);
    cron.schedule('0 0 * * * *', updateCf);
    cron.schedule('45 46 ' + nightHour + ' * * *', User.updateAllUsers);
    cron.schedule('0 */5 * * * *', downloadBlog.run)
    cron.schedule("*/2 * * * * *", submitSubmits)
    cron.schedule("0 */5 * * * *", sendMetrics)
