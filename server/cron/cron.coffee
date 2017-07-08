import Cron from 'cron'
import * as downloadSubmits from "./downloadSubmits"
import * as downloadContests from "./downloadContests"
import updateCf from "./updateCf"

#downloadSubmits.runLast().catch((e) -> console.log(e))
#downloadContests.run().catch((e) -> console.log(e))
updateCf().catch((e) -> console.log(e))

#jobAll = new Cron.CronJob('* * 3 * * *', runAll, null, true);
#jobUntilIgnored = new Cron.CronJob('* */3 * * * *', runUntilIgnored, null, true);
#jobLast = new Cron.CronJob('*/30 * * * * *', runLast, null, true);

#export default [jobAll, jobUntilIgnored, jobLast]
