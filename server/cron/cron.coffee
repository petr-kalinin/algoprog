import Cron from 'cron'
import * as downloadSubmits from "./downloadSubmits"
import * as downloadContests from "./downloadContests"
import {updateAllResults} from '../calculations/updateResults'
import updateCf from "./updateCf"
import logger from '../log'

#downloadSubmits.runUntilIgnored()
#downloadSubmits.runAll().catch((e) -> logger.error(e))
#downloadContests.run().catch((e) -> logger.error(e))
#updateCf().catch((e) -> logger.error(e))

offset = (new Date().getTimezoneOffset()) / 60
MOSCOW_OFFSET = -3
nightHour = (3 + MOSCOW_OFFSET - offset - 1) %% 24

logger.info "Will set downloadAll to " + nightHour + ":59:58 local time"

jobAll = new Cron.CronJob('58 59 ' + nightHour + ' * * *', downloadSubmits.runAll, null, true);
jobUntilIgnored = new Cron.CronJob('59 */3 * * * *', downloadSubmits.runUntilIgnored, null, true);
jobLast = new Cron.CronJob('*/30 * * * * *', downloadSubmits.runLast, null, true);

#jobContests = new Cron.CronJob('0 */10 * * * *', downloadContests.run, null, true);
jobContests = undefined

jobCf = new Cron.CronJob('0 0 * * * *', updateCf, null, true);

jobUpdateResults = new Cron.CronJob('45 45 ' + (nightHour + 1) + ' * * *', updateAllResults, null, true);

export default [jobAll, jobUntilIgnored, jobLast, jobContests, jobCf, jobUpdateResults]
