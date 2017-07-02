import Cron from 'cron'
import {AllSubmitDownloader, UntilIgnoredSubmitDownloader, LastSubmitDownloader, lic40url, zaochUrl} from "./downloadSubmits.js"

jobAll = new Cron.CronJob('* * 3 * * *', () ->
    (new AllSubmitDownloader(lic40url, 'lic40', 1000, 1, 1e9)).run()
    (new AllSubmitDownloader(zaochUrl, 'zaoch', 1000, 1, 1e9)).run()
, null, true);


jobUntilIgnored = new Cron.CronJob('* */3 * * * *', () -> 
    (new UntilIgnoredSubmitDownloader(lic40url, 'lic40', 100, 2, 4)).run()
    (new UntilIgnoredSubmitDownloader(zaochUrl, 'zaoch', 100, 2, 4)).run()
, null, true);

jobLast = new Cron.CronJob('*/30 * * * * *', () ->
            (new LastSubmitDownloader(lic40url, 'lic40', 20, 1, 1)).run()
            (new LastSubmitDownloader(zaochUrl, 'zaoch', 20, 1, 1)).run()
, null, true);

export default [jobAll, jobUntilIgnored, jobLast]
