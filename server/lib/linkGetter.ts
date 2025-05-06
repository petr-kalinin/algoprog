import * as mailparser from 'mailparser'

import { Mutex } from 'async-mutex'
import { SMTPServer, SMTPServerDataStream, SMTPServerSession } from 'smtp-server'

// @ts-ignore
import sleep from './sleep'
import logger from '../log'

const MAX_KEEP_TIME = 2 * 60 * 60 * 1000

export enum OtpFilterType {
    InformaticsActivate
}

function otpFilterFromType(type: OtpFilterType) {
    if (type == OtpFilterType.InformaticsActivate) {
        return ()=>true
    }
}

function otpRegexpFromType(type: OtpFilterType) {
    return RegExp("https:\\/\\/informatics\\.msk\\.ru\\/login\\/confirm\\.php\\?data=\\w+\\/")
}

interface EmailRequest {
    login: string,
    filter: (text: string) => boolean,
    regExp: RegExp,
    usedOtp: string[],
    resolve: (s: string) => void
    reject: (s?: any) => void
    startTime: Date,
    lifeTime: number
    shouldDelete: boolean
}

interface Mail {
    data: mailparser.ParsedMail
    source: string
}

class OtpGetter {
    emailRequests: { [login: string]: EmailRequest } = {}
    running = false
    lastEmailByTo: { [email: string]: Mail } = {}
    server: SMTPServer | undefined

    constructor() {
        this.runSmtp()
        this.dropOldLoop()
    }

    addToLog(s: string) {
        console.log(`[otp] ${s}`)
    }

    async onMessageImpl(message: string, source: string): Promise<void> {
        const mailData = (await mailparser.simpleParser(message))
        const mail: Mail = {
            data: mailData,
            source,
        }
        const to = (mailData.to as mailparser.AddressObject).text
        const request = this.emailRequests[to]
        if (!request) {
            this.addToLog(`Non-interesting email for ${to} ${mailData.subject}, will store for future`)
            this.lastEmailByTo[to] = mail
        } else {
            this.resolveRequest(request, mail)
        }
    }

    resolveRequest(request: EmailRequest, mail: Mail) {
        const to = (mail.data.to as mailparser.AddressObject).text
        const date = mail.data.date!
        const text: string = mail.data.text || mail.data.html || ""
        this.addToLog(`Has message to ${to}: ${mail.data.subject}`)
        if (+date < +request.startTime - request.lifeTime) {
            this.addToLog(`Too old email: ${date} vs ${request.startTime} (lifetime ${request.lifeTime}), ignore`)
            return
        }
        const m = request.regExp.exec(text)
        if (!m) {
            this.addToLog(`Has message to ${to}: no otp found 1`)
            return
        }
        const otp = m![1]
        if (!otp) {
            this.addToLog(`Has message to ${to} ${otp}: no otp found 2`)
            return
        }
        if (!request.filter(text)) {
            this.addToLog(`Has message to ${to} ${otp}: no match to filter`)
            return
        }
        if (request.usedOtp.includes(otp)) {
            this.addToLog(`Has message to ${to} ${otp}: otp already used`)
            return
        }
        this.addToLog(`Found otp for ${to} => ${otp}, will resolve`)
        delete this.emailRequests[to]
        delete this.lastEmailByTo[to]
        request.resolve(otp)
        return
    }

    messageMutex = new Mutex()

    async onMessage(message: string, source: string): Promise<void> {
        await this.messageMutex.runExclusive(() => this.onMessageImpl(message, source))
    }

    async runSmtp() {
        const onData = (stream: SMTPServerDataStream, session: SMTPServerSession, callback: (err?: Error | null) => void) => {
            this.addToLog("[smtp] recv data")
            let text = ""
            stream.on("data", (t) => text += t)
            stream.on("end", async () => {
                this.addToLog("[smtp] Got new email")
                await this.onMessage(text, "smtp")
                //bot.notifyFileText(allOptions.telegramUserId, text, { filename: "message.eml", caption: "New message", contentType: "message/rfc822" })
                callback()
            })
        }

        this.addToLog("[smtp] Will start smtp server")
        this.server = new SMTPServer({
            logger: true,
            authOptional: true,
            onData
        })
        this.server.listen(25, "0.0.0.0")
        this.addToLog("[smtp] Smtp server running")
    }

    async dropOldLoop() {
        while (true) {
            this.addToLog(`Check for old requests`)
            try {
                for (const key in this.emailRequests) {
                    if (+new Date() > +this.emailRequests[key].startTime + this.emailRequests[key].lifeTime) {
                        this.addToLog(`OTP request timedout for key ${key}`)
                        const request = this.emailRequests[key]
                        delete this.emailRequests[key]
                        request.reject(new Error(`OTP request timedout for key ${key}`))
                    }
                }
            } catch (e: any) {
                this.addToLog(`Error in dropOldLoop 1: ${e} ${e.stack}`)
            }
            this.addToLog(`Check for old emails`)
            try {
                for (const key in this.lastEmailByTo) {
                    this.addToLog(`Has probably old email for ${key}: date=${this.lastEmailByTo[key].data.date}, now=${new Date()}`)
                    if (+new Date() > +this.lastEmailByTo[key].data.date! + MAX_KEEP_TIME) {
                        this.addToLog(`Delete old email for ${key}`)
                        delete this.lastEmailByTo[key]
                    }
                }
                this.addToLog(`Done check for old emails`)
            } catch (e: any) {
                this.addToLog(`Error in dropOldLoop 2: ${e} ${e.stack}`)
            }
            await sleep(60 * 1000)
        }
    }

    async getOtp(login: string, filterType: OtpFilterType, usedOtp: string[], lifetime: number): Promise<string> {
        const filterFunc = otpFilterFromType(filterType)
        if(!this.emailRequests[login]) {
            logger.error(`Have two requests for otp ${login}`)
        }
        const result: Promise<string> = new Promise((resolve, reject) => {
            const regExp = otpRegexpFromType(filterType)
            const request: EmailRequest = {
                login: login,
                filter: filterFunc,
                regExp,
                usedOtp: usedOtp,
                resolve: resolve,
                reject: reject,
                startTime: new Date(),
                lifeTime: lifetime,
                shouldDelete: false
            }
            this.emailRequests[login] = request
            if (this.lastEmailByTo[login]) {
                this.resolveRequest(request, this.lastEmailByTo[login])
            }
        })
        return result
    }

}
