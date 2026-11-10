import * as fs from 'fs/promises'
import { CookieJar } from 'request'
const moment = require('moment')
const request = require('request-promise-native')
// @ts-ignore
import { JSDOM } from 'jsdom'
// @ts-ignore
import puppeteer from 'puppeteer-extra'
const StealthPlugin = require('puppeteer-extra-plugin-stealth')
import { Mutex } from 'async-mutex'

// @ts-ignore
import CodeforcesSubmitDownloader from './codeforces/CodeforcesSubmitDownloader'
// @ts-ignore
import TestSystem, {checkOutcome, TestSystemUser} from './TestSystem'
// @ts-ignore
import slowAES from './codeforces/aes.min'

import download, {downloadLimited} from '../lib/download'
// @ts-ignore
import sleep from '../lib/sleep'
// @ts-ignore
import { notify, notifyDocument, notifyDocumentBase64 } from '../lib/telegramBot'
import {BrowserWrapper, PageWrapper} from '../lib/browserWrapper'

// @ts-ignore
import logger from '../log'
// @ts-ignore
import RegisteredUser from '../models/registeredUser'
// @ts-ignore
import User from '../models/user'
// @ts-ignore
import Submit from '../models/submit'
import { chooseRandom } from '../lib/proxyChainForTg'

const TIMEOUT = 250
const REQUESTS_LIMIT = 1
const BASE_URL = "https://codeforces.com"
const BEFORE_PASS_TIMEOUT = 30 * 1000

puppeteer.use(StealthPlugin())

class CodeforcesUser extends TestSystemUser {
    username: string

    constructor(username: string) {
        super()
        this.username = username
    }

    profileLink() {
        return `${BASE_URL}/profile/${this.username}`
    }
}

interface UserCacheEntry {
    user: LoggedCodeforcesUser
    loginTime: Date
}

interface CodeforcesProblemData {
    contest: string
    problem: string
}

interface SubmitData {
    language: string | number
    source: string
    testSystemData: CodeforcesProblemData
}

let userCache: Record<string, UserCacheEntry> = {}
const obfuscatedNames = ["length", "charCodeAt", "floor"] as const

function toNumbers(value: string): number[] {
    const result: number[] = []
    value.replace(/(..)/g, hex => String(result.push(parseInt(hex, 16))))
    return result
}

function toHex(values: number[]): string {
    let result = ""
    for (const value of values) {
        result += (value < 16 ? "0" : "") + value.toString(16)
    }
    return result.toLowerCase()
}

function getRCPC(page: string): string {
    const a = /a=toNumbers\("([^"]*)"\)/.exec(page)![1]
    const b = /b=toNumbers\("([^"]*)"\)/.exec(page)![1]
    const c = /c=toNumbers\("([^"]*)"\)/.exec(page)![1]
    return toHex(slowAES.decrypt(toNumbers(c), 2, toNumbers(a), toNumbers(b)))
}

const PAGE_SCRIPT = `
function getH2a() {
    var xpath = "//p[contains(text(),'you are human')]";
    return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}
function getH2b() {
    var xpath = "//h2[contains(text(),'Performing security verification')]";
    return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}
function getH2() {
    return getH2a() || getH2b()
}
function getTurnstile() {
    return document.getElementsByClassName("cf-turnstile")[0]
}
function alreadyPassed() {
    var val = document.getElementsByName("turnstileToken")[0]?.value
    return val && val != ""
}
function needPass() {
    return !!getH2() || (!!getTurnstile() && !alreadyPassed())
}
function addFakeCheckboxAndClick() {
    if (getH2()) {
        getH2().insertAdjacentHTML('afterend', '<input type="text" id="foobar"/>')
    } else if (getTurnstile()) {
        getTurnstile().insertAdjacentHTML('beforebegin', '<input type="text" id="foobar"/>')
    }
    document.getElementById("foobar").click()
    document.getElementById("foobar").focus()
}
function removeFakeCheckbox() {
    const el = document.getElementById("foobar")
    if (el) {
        el.parentElement.removeChild(el)
    }
}
function clickButton() {
    const el = document.getElementById("finalize-button")
    if (el && !el.disabled) {
        el.click()
        return true
    }
    return false
}
function turnstileSuccess(token) {
    console.log("Turnstile success!")
    const els = document.getElementsByName("turnstileToken")
    for (const el of els) {
        el.value = token
    }
}
function resetTurnstile() {
    const el = getTurnstile()
    const dict = {}
    for (const attr of el.attributes) { 
        if (attr.name.startsWith('data-')) {
            key = attr.name.substring(5)
            dict[key] = attr.value
        }
    }
    console.log("Reset turnstile, dict=", JSON.stringify(dict))
    dict.callback = turnstileSuccess
    turnstile.render('.cf-turnstile', dict)
}
`

let currentProxy: string | undefined = undefined
function changeProxy() {
    currentProxy = chooseRandom(process.env.BOT_PROXIES?.split(';'))
    const oldUserCache = userCache
    userCache = {};
    (async () => {
        for (const key in oldUserCache) {
            try {
                await userCache[key].user.page.browser.close()
            } catch (e) {
                console.log(`Can't close browser for ${key}`)
            }
        }
    })()
    notify(`Changed CF proxy to ${currentProxy}`)
}
changeProxy()

async function addScript(page: PageWrapper) {
    for (let i = 1; ; i++) {
        const result = await page.evaluate(PAGE_SCRIPT)
        console.log(result)
        try {
            await page.evaluate("needPass()")
            break
        } catch {
            console.log("Can't add script, retry")
            await sleep(1000)
            if (i == 10) {
                throw new Error("Can't add script")
            }
        }
    }
}

export class LoggedCodeforcesUser {
    username: string
    password: string
    jar: CookieJar
    requests = 0
    promises: Array<(value: number) => void> = []
    mutex = new Mutex()
    page!: PageWrapper
    handle?: string
    loginPromise!: Promise<void>

    static async getUser(username: string, password: string): Promise<LoggedCodeforcesUser> {
        const key = username + "::" + password
        const cached = userCache[key]
        let isCreatingNew = false
        if (!cached || Date.now() - cached.loginTime.getTime() > 1000 * 60 * 60) {
            logger.info("Creating new CodeforcesUser ", username)
            const newUser = new LoggedCodeforcesUser(username, password)
            userCache[key] = {
                user: newUser,
                loginTime: new Date()
            }
            newUser.loginPromise = newUser.login()
            isCreatingNew = true
        }
        try {
            await userCache[key].user.loginPromise
            logger.info("Created or got from cache new CodeforcesUser ", username)
        } catch (e) {
            if (isCreatingNew) {
                delete userCache[key]
            }
            throw e
        }
        return userCache[key].user
    }

    constructor(username: string, password: string) {
        this.username = username
        this.password = password
        this.jar = request.jar()
    }

    ca76fd64a80cdc35(value: string): number {
        let result = 0
        for (let i = 0; i < value[obfuscatedNames[0]]; i++) {
            result = (result + (i + 1) * (i + 2) * value[obfuscatedNames[1]](i)) % 1009
            if (i % 3 === 0) {
                result++
            }
            if (i % 2 === 0) {
                result *= 2
            }
            if (i > 0) {
                result -= Math[obfuscatedNames[2]](value[obfuscatedNames[1]](Math[obfuscatedNames[2]](i / 2)) / 2) * (result % 5)
            }
            while (result < 0) {
                result += 1009
            }
            while (result >= 1009) {
                result -= 1009
            }
        }
        return result
    }

    tta(): number {
        const cookieString = this.jar.getCookieString(BASE_URL)
        const cookie = /39ce7=(.*)(;|$)/.exec(cookieString)![1]
        return this.ca76fd64a80cdc35(cookie)
    }

    randomNumber(): string {
        return Math.random().toString(36).substr(2)
    }

    randomToken(): string {
        return (this.randomNumber() + this.randomNumber()).substring(0, 18)
    }

    private getCsrf(page: string): string {
        return /<meta name="X-Csrf-Token" content="([^"]*)"/.exec(page)![1]
    }

    private async solveCaptcha() {
        await addScript(this.page)
        if (await this.page.evaluate("(!!getTurnstile() && !alreadyPassed())")) {
            console.log("Need to reset turnstile")
            await this.page.evaluate("resetTurnstile()")
        } else {
            console.log("Don't need to reset turnstile")
        }
        await sleep(10 * 1000)
        console.log("Will disconnect and sleep")
        await this.page.disconnect()
        await sleep(BEFORE_PASS_TIMEOUT)
        console.log("Will reconnect and check")
        await this.page.reconnect()
        await addScript(this.page)
        let count = 0
        const MAX_COUNT = 2
        while (await this.page.evaluate("needPass()") && count < MAX_COUNT) {
            if (await this.page.evaluate("clickButton()")) {
                console.log("Clicked button, sleep")
                await sleep(BEFORE_PASS_TIMEOUT)
                await addScript(this.page)
                continue
            }
            console.log(`Need pass, count=${count}`)
            await this.page.evaluate('addFakeCheckboxAndClick()')
            await this.page.type("#foobar", "aa")
            await sleep(100)
            await this.page.keyboard().press('Tab')
            await sleep(100)
            await this.page.keyboard().press('Space')
            console.log("Done click")
            console.log("Will disconnect and sleep")
            await this.page.disconnect()
            await sleep(BEFORE_PASS_TIMEOUT)
            console.log("Will reconnect and check")
            await this.page.reconnect()
            await addScript(this.page)
            await this.page.evaluate('removeFakeCheckbox()')
            const getH2 = await this.page.evaluate("!!getH2()")
            const getTurnstile = await this.page.evaluate("!!getTurnstile()")
            const alreadyPassed = await this.page.evaluate("alreadyPassed()")
            console.log(`Current captcha status = getH2=${getH2} getTurnstile=${getTurnstile} alreadyPassed=${alreadyPassed} count=${count}`)
            count++
        }
        const netlog = await fs.readFile(this.page.browser.netlogFile)
        notifyDocument(netlog, { filename: 'netlog.json', contentType: "application/json" })
        if (count == MAX_COUNT) {
            throw new Error(`Can't pass captcha`)
        }
        console.log(`Passed captcha, count=${count}`)
        await sleep(BEFORE_PASS_TIMEOUT)
    }

    private async loginImpl() {
        logger.info("Logging in new CodeforcesUser ", this.username)
        if (!this.username) {
            throw "Unknown user"
        }
        const browser = await BrowserWrapper.create("", puppeteer as any, "cf", currentProxy, console.log)
        try {
            this.page = await PageWrapper.Create(puppeteer as any, browser, "", console.log)
            await this.page.goto(`${BASE_URL}/enter`)
            await this.solveCaptcha()
            await this.page.goto(`${BASE_URL}/enter`)
            await sleep(BEFORE_PASS_TIMEOUT)
            await this.page.type("#handleOrEmail", this.username)
            console.log(`---4 ${this.username}`)
            await this.page.type("#password", this.password)
            console.log(`---5 ${this.username}`)
            console.log(`---6 ${this.username}`)
            await this.page.click(".submit")
            console.log(`---7 ${this.username}`)
            await sleep(BEFORE_PASS_TIMEOUT)
            console.log(`---8 ${this.username}`)
            const cookies = await this.page.cookies()
            console.log(`---9 ${this.username}`)
            for (const cookie of cookies) {
                this.jar.setCookie(`${cookie.name}=${cookie.value}`, BASE_URL)
            }
            const content = await this.page.content()
            console.log(`---10 ${this.username}`)
            if (content.includes("Некорректный хэндл/email или пароль") || content.includes("Invalid handle/email or password")) {
                throw {badPassword: true}
            }
            console.log(`---11 ${this.username}`)
            this.handle = /<a href="\/profile\/([^"]*)">[^<]*<\/a>\s*|\s*<a href="\/[^"]*\/logout">/.exec(content)?.[1]
            console.log(`---12 ${this.username}`)
            if (!this.handle) {
                notifyDocument(content, {filename: 'page.html', contentType: "text/html"})
                throw `Can not log user ${this.username} in: no handle in response`
            }
            logger.info("Logged in new CodeforcesUser ", this.username, this.handle)
        } catch (e: any) {
            const screenshot = await this.page.screenshot({type: "png"})
            logger.error(`Can not log in new Codeforces user ${this.username}`, e.message, e)
            if (!e.badPassword) {
                notify(`Can not log in new Codeforces user ${this.username}: ${e} ${e.message}`)
                notifyDocument(await this.page.content(), {filename: 'page.html', contentType: "text/html"})
                notifyDocumentBase64(screenshot, {filename: 'screenshot.png', contentType: "image/png"})
                changeProxy()
            }
            try {
                await browser?.close()
            } catch {
                logger.error("Can't close browser")
            }
            throw e
        }
    }

    private async login() {
        await this.mutex.runExclusive(this.loginImpl.bind(this))
    }

    async download(href: string, options: any = {}): Promise<string> {
        if (this.requests >= REQUESTS_LIMIT) {
            await new Promise<number>(resolve => this.promises.push(resolve))
        }
        if (this.requests >= REQUESTS_LIMIT) {
            throw "Too many requests"
        }
        this.requests++
        await sleep(TIMEOUT)
        options.maxAttempts = 1
        options.timeout = 30 * 1000
        try {
            return await download(href, this.jar, options)
        } finally {
            this.requests--
            this.promises.shift()?.(0)
        }
    }

    async submit(problemId: string, contentType: string, body: unknown) {
        throw "Not implemented"
    }

    private async submitWithObjectImpl(problemId: string, data: SubmitData) {
        const {contest, problem} = data.testSystemData
        const isGym = contest.startsWith("gym")
        const href = isGym
            ? `${BASE_URL}/${contest}/submit`
            : `${BASE_URL}/problemset/problem/${contest}/${problem}`

        await this.page.goto(href)
        try {
            await this.solveCaptcha()
        } catch (e) {
            const content0 = await this.page.content()
            const screenshot0 = await this.page.screenshot({ type: "png" })
            notify("Can't submit to CF")
            notifyDocument(content0, { filename: 'page0.html', contentType: "text/html" })
            notifyDocumentBase64(screenshot0, { filename: 'screenshot0.png', contentType: "image/png" })
            logger.error("Can't submit")
            changeProxy()
            throw e
        }
        const content0 = await this.page.content()
        const screenshot0 = await this.page.screenshot({type: "png"})
        if (this.page.url() != href) {
            await this.page.goto(href)
            await sleep(BEFORE_PASS_TIMEOUT)
        }

        const inputUploadHandle = await this.page.$('input[type=file]')
        if (!inputUploadHandle) {
            throw new Error("No file upload!!!")
        }
        const path = "/tmp/sources"
        await fs.mkdir(path, {recursive: true})
        const fileToUpload = `${path}/${Math.random().toString(36).substr(2)}`
        await fs.writeFile(fileToUpload, Buffer.from(data.source, "latin1") as any)
        await (inputUploadHandle as any).uploadFile(fileToUpload)
        await this.page.evaluate(`document.getElementsByName('programTypeId')[0].value = '${data.language}'`)
        if (isGym) {
            await this.page.evaluate(`document.getElementsByName('submittedProblemIndex')[0].value = '${problem}'`)
        }
        await this.page.evaluate("document.querySelector('.submit').disabled = false")
        await this.page.click(".submit")
        await this.solveCaptcha()
        const content = await this.page.content()
        const screenshot = await this.page.screenshot({ type: "png" })
        if (content.includes("You have submitted exactly the same code before")) {
            logger.info("Submit is a duplicate")
            throw {duplicate: true}
        }
        if (content.includes("the programming language of these submissions differs from the selected language")) {
            logger.info("The programming language of these submissions differs from the selected language")
            throw {contactMe: true}
        }
        if (!content.includes("Contest status") && !content.includes(" My Submissions") && !content.includes("Last submissions")) {
            notify("Can't submit to CF")
            notifyDocument(content0, {filename: 'page0.html', contentType: "text/html"})
            notifyDocument(content, {filename: 'page.html', contentType: "text/html"})
            notifyDocumentBase64(screenshot0, { filename: 'screenshot0.png', contentType: "image/png" })
            notifyDocumentBase64(screenshot, { filename: 'screenshot.png', contentType: "image/png" })
            logger.error("Can't submit")
            changeProxy()
            throw "Can't submit"
        }
        logger.info("Apparently submitted!")
    }

    async submitWithObject(problemId: string, data: SubmitData) {
        await this.mutex.runExclusive(() => this.submitWithObjectImpl(problemId, data))
    }

    private async getSourceAndResultsImpl(runid: string) {
        logger.info(`Will download source and results for ${runid}`)
        await this.page.goto(`${BASE_URL}/submissions/${this.username}`)
        const csrf = this.getCsrf(await this.page.content())
        const formData = new URLSearchParams({
            csrf_token: csrf,
            submissionId: runid
        })
        const code = `(async () => await (await fetch('${BASE_URL}/data/submitSource', {
            'headers': {
                'cache-control': 'no-cache',
                'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'pragma': 'no-cache',
                'x-csrf-token': '${csrf}',
                'x-requested-with': 'XMLHttpRequest'
            },
            'referrer': '${BASE_URL}/submissions/${this.username}',
            'body': '${formData.toString()}',
            'method': 'POST',
            'mode': 'cors',
            'credentials': 'include'
        })).json())()`
        return this.page.evaluate(code)
    }

    async _getSourceAndResults(runid: string) {
        return this.mutex.runExclusive(() => this.getSourceAndResultsImpl(runid))
    }

    private async getSubmitsFromGymImpl(
        contest: string,
        problem: string,
        realUser: any,
        realProblem: any,
        correctOutcome: (outcome: string) => string
    ) {
        const url = `${BASE_URL}/${contest}/my`
        logger.info(`Will get submits from gym, url=${url}`)
        await this.page.goto(url)
        const content = await this.page.content()
        const document = new JSDOM(content, {url}).window.document
        const table = document.getElementsByClassName("status-frame-datatable")[0]
        const rows = Array.from(table?.getElementsByTagName("tr") || []) as HTMLTableRowElement[]
        const result: any[] = []
        const baseProbHref = `${BASE_URL}/${contest}/problem/`
        let count = 0
        for (const row of rows) {
            const id = row.children[0]?.textContent?.trim()
            const timeText = row.children[1]?.textContent?.trim()
            const user = row.children[2]?.textContent?.trim()
            const problemHref = row.children[3]?.getElementsByTagName("a")[0]?.href?.trim()
            const language = row.children[4]?.textContent?.trim()
            let outcome = row.children[5]?.textContent?.trim()
            if (!problemHref || !problemHref.startsWith(baseProbHref)) {
                logger.info("Ignoring problem ", problemHref)
                continue
            }
            count++
            const foundProblem = problemHref.substring(baseProbHref.length)
            const time = moment(timeText, "MMM/DD/YYYY HH:mm", true).subtract(3, 'hours').toDate()
            if (outcome == "In queue" || outcome?.startsWith("Running")) {
                outcome = "CT"
            } else if (outcome == "Compilation error") {
                outcome = "CE"
            } else if (outcome == "Вы уже отправляли этот код") {
                outcome = "DP"
            } else if (outcome == "Accepted") {
                outcome = "OK"
            }
            if (user?.toLowerCase() != this.username.toLowerCase()) {
                throw `Strange submit: found username ${user}, expected ${this.username}`
            }
            if (foundProblem != problem) {
                logger.info(`Skipping submit ${id} because it is for a different problem: ${foundProblem} vs ${problem}`)
                continue
            }
            outcome = correctOutcome(outcome || "")
            console.log(`found id=${id}, time=${time}, user=${user}, prob=${foundProblem}, lang=${language}, outcome=${outcome}`)
            result.push(new Submit({
                _id: "c" + id,
                time,
                user: realUser,
                problem: realProblem,
                outcome,
                language,
                testSystemData: {
                    runId: id,
                    contest,
                    problem,
                    system: "codeforces",
                    username: this.username
                }
            }))
            checkOutcome(outcome)
        }
        if (count == 0) {
            notify("No submits found in CF table")
            notifyDocument(content, {filename: 'page.html', contentType: "text/html"})
            changeProxy()
        }
        return result
    }

    async getSubmitsFromGym(
        contest: string,
        problem: string,
        realUser: any,
        realProblem: any,
        correctOutcome: (outcome: string) => string
    ) {
        return this.mutex.runExclusive(() => this.getSubmitsFromGymImpl(contest, problem, realUser, realProblem, correctOutcome))
    }
}

export default class Codeforces extends TestSystem {
    private async getAdmin() {
        const admin = await RegisteredUser.findAdmin()
        if (!admin) {
            return undefined
        }
        return LoggedCodeforcesUser.getUser(admin.codeforcesUsername, admin.codeforcesPassword)
    }

    id() {
        return "codeforces"
    }

    async submitDownloader(registeredUser: any, problem: any, submitsPerPage: number) {
        const member = await this.getMemberFromTeam(registeredUser)
        const username = member.codeforcesUsername
        const contest = problem.testSystemData.contest
        const codeforcesProblem = problem.testSystemData.problem
        const loggedUser = await LoggedCodeforcesUser.getUser(member.codeforcesUsername, member.codeforcesPassword)
        return new CodeforcesSubmitDownloader(BASE_URL, username, contest, codeforcesProblem, registeredUser.userKey(), problem._id, loggedUser)
    }

    submitNeedsFormData() {
        return false
    }

    private async getMemberFromTeam(registeredUser: any) {
        if (registeredUser.codeforcesUsername) {
            return registeredUser
        }
        const fullUser = await User.findById(registeredUser.userKey())
        for (const memberKey of fullUser.members) {
            const member = await RegisteredUser.findByKeyWithPassword(memberKey)
            if (member?.codeforcesUsername) {
                return member
            }
        }
        throw "Can't find user with required data"
    }

    async submitWithObject(registeredUser: any, problemId: string, data: SubmitData) {
        const member = await this.getMemberFromTeam(registeredUser)
        const {contest, problem} = data.testSystemData
        logger.info(`Try submit ${registeredUser.username}, ${registeredUser.userKey()} ${member.codeforcesUsername} ${problemId} ${contest} ${problem}`)
        if (!member.codeforcesUsername) {
            throw "No codeforces username given"
        }
        const codeforcesUser = await LoggedCodeforcesUser.getUser(member.codeforcesUsername, member.codeforcesPassword)
        await codeforcesUser.submitWithObject(problem, data)
    }

    async registerUser(user: any) {
        logger.info("Do nothing to register user in codeforces")
    }

    async selfTest() {
        // Intentionally empty.
    }

    async downloadProblem(options: any, label: string) {
        let locale: string
        if (label == "") {
            locale = "ru"
        } else if (label == "!en") {
            locale = "en"
        } else {
            throw `Don't know locale for label ${label}`
        }
        const href = options.contest.startsWith("gym")
            ? `${BASE_URL}/${options.contest}/problem/${options.problem}?locale=${locale}`
            : `${BASE_URL}/problemset/problem/${options.contest}/${options.problem}?locale=${locale}`
        let page = await downloadLimited(href, undefined as any, {timeout: 15 * 1000})
        if (page.includes("Redirecting... Please, wait.")) {
            const jar = request.jar()
            const RCPC = getRCPC(page)
            jar.setCookie(`RCPC=${RCPC}`, BASE_URL)
            logger.info("Cf pre-login cookie=", jar.getCookieString(BASE_URL))
            page = await download(`${href}&f0a28=1`, jar)
        }
        const document = new JSDOM(page, {url: href}).window.document
        const statements = document.getElementsByClassName("problem-statement")
        if (!statements?.length) {
            logger.warn("Can't find statement for problem " + href)
            const seeCfStatement = label == "" ? "См. условие на codeforces" : "See statement on codeforces"
            const name = options.name || "???"
            return {name, text: `<h1>${name}</h1> <div>${seeCfStatement}:</div>`}
        }
        const statement = statements[0]
        const nameElement = statement.getElementsByClassName("title")[0]
        let name = nameElement?.innerHTML.substring(3)
        nameElement?.parentElement?.removeChild(nameElement)
        if (!name) {
            logger.warn(Error("Can't find name for problem " + href))
            name = "???"
        }
        let text = "<h1>" + name + "</h1>"
        text += `<div class='codeforces-statement'>${statement.innerHTML}</div>`
        text = text.replace(/\$\$\$/g, "$")
        return {name, text}
    }

    getProblemId(options: CodeforcesProblemData) {
        const contest = options.contest.replace("/", "")
        return `c${contest}p${options.problem}`
    }

    getProblemData(options: CodeforcesProblemData): CodeforcesProblemData {
        return {
            contest: options.contest,
            problem: options.problem
        }
    }
}
