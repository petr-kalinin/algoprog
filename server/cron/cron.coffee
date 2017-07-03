import Cron from 'cron'
import * as downloadSubmits from "./downloadSubmits.js"
import * as downloadContests from "./downloadContests.js"

#downloadSubmits.runLast()
downloadContests.run()

#jobAll = new Cron.CronJob('* * 3 * * *', runAll, null, true);
#jobUntilIgnored = new Cron.CronJob('* */3 * * * *', runUntilIgnored, null, true);
#jobLast = new Cron.CronJob('*/30 * * * * *', runLast, null, true);

#export default [jobAll, jobUntilIgnored, jobLast]
