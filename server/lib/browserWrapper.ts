import {WebSocket} from 'ws'
import * as fs from 'fs/promises'

// @ts-ignore
import sleep from './sleep'

import { Browser, CDPSession, Frame, FrameAddScriptTagOptions, FrameWaitForFunctionOptions, GoToOptions, HTTPRequest, HTTPResponse, Page, Protocol, Puppeteer, PuppeteerNode, WaitForOptions, WaitForSelectorOptions } from 'puppeteer'

export class BrowserWrapper {
    id!: string
    browser!: Browser
    dirPrefix!: string
    userDataDir!: string
    netlogFile!: string
    netlogToKeepSuffix: string|undefined
    pid: number|undefined
    addToLog!: (msg: string) => void
    finished: boolean = false
    ws!: WebSocket

    private constructor() {}

    async hideUserAgent() {
        const SEND = async (ws: WebSocket, command: any): Promise<any> => {
            //this.addToLog(`Send: ${JSON.stringify(command)}`)
            ws.send(JSON.stringify(command))
            return new Promise(resolve => {
                const listener = function (text: string) {
                    const response = JSON.parse(text)
                    if (response.id === command.id) {
                        ws.removeListener('message', listener)
                        resolve(response)
                    }
                }
                ws.on('message', listener)
            })
        }
        this.ws = new WebSocket(this.browser.wsEndpoint(), { perMessageDeflate: false })
        /*this.ws.on('message', (text) => {
            this.addToLog!(`Got message ${text}`)
        })*/
        await new Promise(resolve => this.ws.once('open', resolve))
        let globalId = 1
        this.ws.on('message', async (text: any) => {
            const msg = JSON.parse(text)
            //this.addToLog(`Listener got message ${JSON.stringify(msg)}`)
            if (msg.method == "Target.targetCreated") {
                const url = msg.params.targetInfo.url
                if (url.startsWith('devtools')) {
                    return
                }
                //this.addToLog(`New page: ${url}`)
                const sessionId = (await SEND(this.ws, {
                    id: globalId++,
                    method: "Target.attachToTarget",
                    params: {
                        targetId: msg.params.targetInfo.targetId,
                        flatten: true,
                    }
                })).result.sessionId
                //this.addToLog(`Sessionid=${sessionId}`)
                const resp = await SEND(this.ws, {
                    sessionId,
                    id: 1, // Note that IDs are independent between sessions.
                    method: 'Network.setUserAgentOverride',
                    params: {
                        "userAgent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36",
                        "userAgentMetadata": {
                            "brands": [
                                {
                                    "brand": "Not A;Brand",
                                    "version": "99"
                                },
                                {
                                    "brand": "Chromium",
                                    "version": "133"
                                },
                                {
                                    "brand": "Google Chrome",
                                    "version": "133"
                                }
                            ],
                            "fullVersion": "133.0.0.0",
                            "platform": "Windows",
                            "platformVersion": "10.0",
                            "architecture": "x86",
                            "model": "",
                            "mobile": false
                        }
                    },
                })
                //this.addToLog(`Resp to userAgent=${JSON.stringify(resp)}`)
            }
        })
        const targetsResponse = await SEND(this.ws, {
            id: globalId++,
            method: 'Target.setDiscoverTargets',
            params: {
                discover: true
            }
        })
        //this.addToLog(`resp=${JSON.stringify(targetsResponse)}`)
    }

    static async create(id: string, puppeteer: PuppeteerNode, dirPrefix: string, priority: number, addToLog: (msg: string) => void ) {
        const wrapper = new BrowserWrapper()
        wrapper.id = id
        wrapper.addToLog = addToLog
        wrapper.dirPrefix = dirPrefix
        const rnd = (Math.random() + 1).toString(36).substring(2)
        wrapper.userDataDir = `/tmp/${dirPrefix}_${rnd}`
        addToLog(`userDataDir=${wrapper.userDataDir}`)

        wrapper.browser = await puppeteer.launch({
            headless: true,
            devtools: false,
            args: [
                '--user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36',
                '--disable-gpu',
                '--no-sandbox',
                '--disk-cache-dir=/dev/null',
                `--user-data-dir=${wrapper.userDataDir}`,
                '--disable-client-side-phishing-detection',
                '--disable-component-extensions-with-background-pages',
                '--disable-default-apps',
                '--disable-features=InterestFeedContentSuggestions',
                '--no-default-browser-check',
                '--no-first-run',
                '--ash-no-nudges',
                '--aggressive-cache-discard',
                '--disable-back-forward-cache',
                '--disable-features=IsolateOrigins',
                '--disable-background-networking',
                '--disable-component-update',
                '--disable-features=OptimizationHints',
                //'--single-process',
            ],
            targetFilter: (target: any) => !!target.url,
        })
        wrapper.pid = wrapper.browser.process()?.pid
        wrapper.addToLog(`Launched browser pid=${wrapper.pid}`)
        wrapper.hideUserAgent()
        return wrapper
    }

    async setNetlogToKeepSuffix(suffix: string) {
        this.netlogToKeepSuffix = suffix
    }

    async close() {
        this.ws.close()
        const pid = this.pid
        this.finished = true
        try {
            this.addToLog(`Will close browser pid=${pid}`)
            await this.browser.close()
            if (pid) {
                try {
                    process.kill(pid)
                } catch (e) {
                    this.addToLog(`Can't kill pid=${pid}: ${e}`)
                }
                await sleep(5000)
                try {
                    process.kill(pid, 'SIGKILL')
                } catch (e) {
                    this.addToLog(`Can't kill with SIGKILL pid=${pid}: ${e}`)
                }
            }
        } finally {
            this.addToLog(`Will remove dir ${this.userDataDir}`)
            await fs.rm(this.userDataDir, { recursive: true, force: true, maxRetries: 100 })
            if (this.netlogFile) {
                await fs.rm(this.netlogFile, { recursive: true, force: true, maxRetries: 100 })
            }
        }
    }
}

export class PageWrapper {
    page!: Page
    id!: string
    browser!: BrowserWrapper
    browserWSEndpoint!: string
    puppeteer!: Puppeteer
    _addToLog: ((msg: string) => void) | undefined = undefined
    pid!: number
    session!: CDPSession
    authData: {proxy: string, username: string, password: string}[] = []

    private constructor() { }

    static async Create(puppeteer: Puppeteer, browser: BrowserWrapper, id: string, addToLog?: (msg: string) => void) {
        const result = new PageWrapper()
        result.id = id
        result._addToLog = addToLog
        result.browser = browser
        result.browserWSEndpoint = result.browser.browser.wsEndpoint()
        result.puppeteer = puppeteer
        if (addToLog) {
            addToLog(`Will create new page, has ${(await result.browser.browser.pages()).length} pages`)
        }
        result.page = (await result.browser.browser.pages())[0]
        if (addToLog) {
            addToLog(`Existing page url=${result.page.url()}`)
        }
        result.pid = browser.browser.process()!.pid!
        return result
    }

    addToLog(msg: string) {
        console.log(">>> " + msg)
    }

    async $(selector: string) {
        this.addToLog(`$(selector)`)
        try {
            return this.page.$(selector)
        } catch (e: any) {
            e.message = e.message + ": " + selector.toString()
            throw e
        }
    }

    async frames() {
        return this.page.frames()
    }

    async initInterception<T>(notifyBadRequest: (msg: string) => void, processRequest: (request: HTTPRequest) => boolean, processResponse: (request: HTTPRequest, response: HTTPResponse) => Promise<void>) {
        await this.page.setRequestInterception(true)
        this.page.removeAllListeners("request")
        this.page.removeAllListeners("requestfinished")
        this.page.removeAllListeners("requestfailed")
        this.page.on('request', (request) => {
            if (!processRequest(request)) {
                request.continue()
            }
        })
        const onRequest = async (request: HTTPRequest) => {
            const response = request.response()
            if (!response) {
                notifyBadRequest(`Bad request: no response, url=${request.url()}, errText: ${request.failure()?.errorText}, postData=${request.postData()}`.substr(0, 2000))
                return
            }
            const status = response.status()
            if (status >= 400) {
                try {
                    const resp = await response.text()
                    notifyBadRequest(`Bad request: status=${status}, url=${request.url()}, postData=${request.postData()?.substring(0, 2000)}, resp=${resp.substring(0, 300)}}`.substr(0, 2000))
                } catch (e) {
                }
            }
            await processResponse(request, response)
        }
        this.page.on('requestfinished', onRequest)
        this.page.on('requestfailed', onRequest)
    }

    async authenticate(proxy: string, username: string, password: string) {
        this.addToLog("authenticate")
        this.authData.push({proxy, username, password})
        //await this.page.authenticate(o)
    }

    async goto(url: string, options?: GoToOptions) {
        this.addToLog(`goto(${url})`)
        await this.page.goto(url, options)
    }

    async setViewport(o: any) {
        this.addToLog(`setViewport(${o})`)
        await this.page.setViewport(o)
    }

    removeAllListeners(event: string) {
        return this.page.removeAllListeners(event)
    }

    on(event: string, handler: any) {
        return this.page.on(event, handler)
    }

    async screenshot(o: any) {
        this.addToLog(`screenshot(${o})`)
        try {
            return await this.page.screenshot({...o, encoding: 'base64'})
        } catch (e) {
            this.addToLog("Can not make screenshot: " + e)
        }
    }

    cookies() {
        return this.page.cookies()
    }

    async waitForNavigation(options?: WaitForOptions) {
        this.addToLog(`waitForNavigation()`)
        await this.page.waitForNavigation(options)
    }

    url() {
        try {
            return this.page.url()
        } catch (e) {
            return "http://error.com"
        }
    }

    isClosed() {
        return this.page.isClosed()
    }

    setDefaultTimeout(x: any) {
        this.page.setDefaultTimeout(x)
    }

    async waitForFunction(s: any, options?: FrameWaitForFunctionOptions) {
        this.addToLog(`waitForFunction(${s})`)
        try {
            await this.page.waitForFunction(s, options)
        } catch (e: any) {
            e.message = e.message + ": " + s.toString()
            throw e
        }
    }

    async waitForSelector(s: string, options?: WaitForSelectorOptions) {
        this.addToLog(`waitForSelector(${s})`)
        try {
            await this.page.waitForSelector(s, options)
        } catch (e: any) {
            e.message = e.message + ": " + s.toString()
            throw e
        }
    }

    async reload() {
        this.addToLog(`reload()`)
        await this.page.reload()
    }

    async type(a: any, b: any) {
        this.addToLog(`type(${a}, ${b})`)
        await this.page.type(a, b)
    }

    async solveRecaptchas() {
        this.addToLog(`solveRecaptchas()`)
        // @ts-ignore
        await this.page.solveRecaptchas()
    }

    async click(s: any) {
        this.addToLog(`click(${s})`)
        await this.page.click(s)
    }

    async evaluate(a: any, b?: any, c?: any, d?: any) {
        this.addToLog(`evaluate(${a})`)
        try {
            return await this.page.evaluate(a, b, c, d)
        } catch (e: any) {
            e.message = e.message + ": " + a.toString()
            throw e
        }
    }

    async content() {
        return this.page.content()
    }

    async disconnect() {
        this.addToLog("disconnect")
        await this.browser.browser.disconnect()
    }

    async reconnect() {
        this.addToLog("reconnect")
        this.browser.browser = await this.puppeteer.connect({ browserWSEndpoint: this.browserWSEndpoint })
        this.page = (await this.browser.browser.pages())[0]
        if (!this.page) {
            this.addToLog("Page not found when reconnecting, will create new page")
            this.page = await this.browser.browser.newPage()
        }
    }

    keyboard() {
        return this.page.keyboard
    }

    async closeBrowser() {
        await this.browser.close()
    }

    async onRequestPaused(event: Protocol.Fetch.RequestPausedEvent) {
        try {
            await this.session.send('Fetch.continueRequest', {
                requestId: event.requestId,
            })
        } catch (e: any) {
            this.addToLog(`Can't continue request: ${e}`)
        }
    }

    async onAuthRequired(event: Protocol.Fetch.AuthRequiredEvent) {
        try {
            const response: Protocol.Fetch.AuthChallengeResponse = {
                response: "ProvideCredentials",
            }
            this.addToLog(`Has request for auth for ${event.authChallenge.origin}`)
            for (const data of this.authData) {
                this.addToLog(`Has auth data for ${data.proxy}`)
                if (event.authChallenge.origin.includes(data.proxy)) {
                    response.username = data.username
                    response.password = data.password
                    this.addToLog(`>>>>> will provide auth for ${event.authChallenge.origin} = ${data.proxy}`)
                }
            }
            if (!response.username) {
                this.addToLog(`>>>>> Can't find auth for ${event.authChallenge.origin}`)
            }
            await this.session.send('Fetch.continueWithAuth', {
                requestId: event.requestId,
                authChallengeResponse: response,
            })
        } catch (e: any) {
            this.addToLog(`Can't provide auth: ${e}`)
        }
    }
}
