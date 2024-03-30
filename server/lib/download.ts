import { CookieJar } from 'request'
import request = require('request-promise-native')

// @ts-ignore
import logger from '../log'
// @ts-ignore
import sleep from './sleep'

const statistics = {
    ok: 0,
    fail: 0
}

const STATS_MULTIPLIER = 1 - 1.0/100

const isDev = !process.env.NODE_ENV || process.env.NODE_ENV == 'development'
const mode = isDev ? "dev" : "clone"
const USER_AGENT = process.env.USER_AGENT || `algoprog.ru [${mode}]`
console.log("User-Agent=", USER_AGENT)

function addStats(type: string) {
    for (const t in statistics) {
        statistics[t] *= STATS_MULTIPLIER
    }
    statistics[type] += 1
}

export function getStats() {
    return statistics
}

interface Options extends request.RequestPromiseOptions {
    maxAttempts?: number
}

export default async function download(href: string, jar: CookieJar, options: Options={}): Promise<string> {
    logger.info("Downloading", href)
    if (!jar) {
        jar = request.jar()
    }
    let delay = 5
    const maxAttempts = options?.maxAttempts || 1
    options.headers = options.headers || {}
    options.headers["User-Agent"] = USER_AGENT
    for (let i = 0; i < maxAttempts; i++) {
        try {
            const page = await request({
                ...options,
                url: href,
                jar: jar,
                gzip: true,
                timeout: options?.timeout || 7 * 1000
            })
            addStats("ok")
            return page
        } catch (e) {
            logger.info("Error downloading " + href + " " + i + " will re-download", e.message, delay, options?.timeout)
            await sleep(delay)
            delay *= 2
        }
    }
    addStats("fail")
    throw "Can't download " + href
}

let requests = 0
const promises = []
const REQUESTS_LIMIT = 10

export async function downloadLimited(href: string, jar: CookieJar, options: Options): Promise<string> {
        if (requests >= REQUESTS_LIMIT) {
            await new Promise((resolve) => promises.push(resolve))
        }
        if (requests >= REQUESTS_LIMIT) {
            throw "Too many requests"
        }
        requests++
        let result = ""
        try {
            result = await download(href, jar, options)
        } finally {
            requests--
            if (promises.length) {
                const promise = promises.shift()
                promise(0)  // resolve
            }
        }
        return result
}