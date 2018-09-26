import Cron from 'cron'
import * as downloadSubmits from "./downloadSubmits"
#import * as downloadContests from "./downloadContests"
import * as downloadBlog from './downloadBlog'
import updateCf from "./updateCf"
import submitSubmits from './submitSubmits'
import sendMetrics from './sendMetrics'

import logger from '../log'
import User from '../models/user'

#downloadSubmits.runUntilIgnored()
#downloadSubmits.runAll().catch((e) -> logger.error(e))
#downloadContests.run().catch((e) -> logger.error(e))
#updateCf().catch((e) -> logger.error(e))

offset = (new Date().getTimezoneOffset()) / 60
MOSCOW_OFFSET = -3
nightHour = (3 + MOSCOW_OFFSET - offset - 1) %% 24

logger.info "Will set downloadAll to " + nightHour + ":59:58 local time"

jobCT = new Cron.CronJob('*/10 * * * * *', downloadSubmits.runForCT);

jobCf = new Cron.CronJob('0 0 * * * *', updateCf);

jobUpdateResults = new Cron.CronJob('45 46 ' + (nightHour + 1) + ' * * *', User.updateAllUsers);

jobUpdateBlog = new Cron.CronJob('0 */5 * * * *', downloadBlog.run)

jobSubmitSubmits = new Cron.CronJob("*/2 * * * * *", submitSubmits)

jobSendMetrics = new Cron.CronJob("0 */5 * * * *", sendMetrics)

export default [jobCT, jobCf, jobUpdateResults, jobUpdateBlog, jobSubmitSubmits, jobSendMetrics]

#downloadSubmits.runLast()