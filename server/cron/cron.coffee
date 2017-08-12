import Cron from 'cron'
import * as downloadSubmits from "./downloadSubmits"
import * as downloadContests from "./downloadContests"
import updateCf from "./updateCf"
import logger from '../log'

#downloadSubmits.runAll().catch((e) -> logger.error(e))
#downloadContests.run().catch((e) -> logger.error(e))
#updateCf().catch((e) -> logger.error(e))

jobAll = new Cron.CronJob('58 59 2 * * *', downloadSubmits.runAll, null, true);
jobUntilIgnored = new Cron.CronJob('59 */3 * * * *', downloadSubmits.runUntilIgnored, null, true);
jobLast = new Cron.CronJob('*/30 * * * * *', downloadSubmits.runLast, null, true);

#jobContests = new Cron.CronJob('0 */10 * * * *', downloadContests.run, null, true);
jobContests = undefined

jobCf = new Cron.CronJob('0 0 * * * *', updateCf, null, true);

export default [jobAll, jobUntilIgnored, jobLast, jobContests, jobCf]
