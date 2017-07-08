import Cron from 'cron'
import * as downloadSubmits from "./downloadSubmits"
import * as downloadContests from "./downloadContests"
import updateCf from "./updateCf"

#downloadSubmits.runLast().catch((e) -> console.log(e))
#downloadContests.run().catch((e) -> console.log(e))
#updateCf().catch((e) -> console.log(e))

jobAll = new Cron.CronJob('0 0 3 * * *', downloadSubmits.runAll, null, true);
jobUntilIgnored = new Cron.CronJob('0 */3 * * * *', downloadSubmits.runUntilIgnored, null, true);
jobLast = new Cron.CronJob('*/30 * * * * *', downloadSubmits.runLast, null, true);

jobContests = new Cron.CronJob('0 */5 * * * *', downloadContests.run, null, true);

jobCf = new Cron.CronJob('0 0 * * * *', updateCf, null, true);

export default [jobAll, jobUntilIgnored, jobLast, jobContests, jobCf]
