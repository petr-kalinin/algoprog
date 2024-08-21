moment = require('moment')
iconv = require('iconv-lite')

import { JSDOM } from 'jsdom'

import TestSystemSubmitDownloader, {checkOutcome} from '../TestSystem'

import logger from '../../log'
import download from '../../lib/download'
import normalizeCode from '../../lib/normalizeCode'
import sleep from '../../lib/sleep'
import {notify, notifyDocument} from '../../lib/telegramBot'
import Submit from '../../models/submit'

import LANGUAGES from '../../../client/lib/languages'

TIMEOUT = 250
lastRunTime = new Date() - TIMEOUT
REQUESTS_LIMIT = 1
requests = 0
promises = []

downloadLimited = (href, options) ->
    if requests >= REQUESTS_LIMIT
        await new Promise((resolve) => promises.push(resolve))
    if requests >= REQUESTS_LIMIT
        throw "Too many requests"
    requests++
    await sleep(TIMEOUT)
    try
        result = await download(href, undefined, options)
    finally
        requests--
        if promises.length
            promise = promises.shift()
            promise(0)  # resolve
    return result


export default class CodeforcesSubmitDownloader extends TestSystemSubmitDownloader
    constructor: (@baseUrl, @username, @contest, @problem, @realUser, @realProblem, @loggedUser) ->
        super()

    VERDICTS: 
        FAILED: "FL", 
        OK: "OK", 
        PARTIAL: "WA", 
        COMPILATION_ERROR: "CE", 
        RUNTIME_ERROR: "RE", 
        WRONG_ANSWER: "WA", 
        PRESENTATION_ERROR: "PE", 
        TIME_LIMIT_EXCEEDED: "TL", 
        MEMORY_LIMIT_EXCEEDED: "ML", 
        IDLENESS_LIMIT_EXCEEDED: "TL", 
        SECURITY_VIOLATED: "SV", 
        CRASHED: "RE", 
        INPUT_PREPARATION_CRASHED: "FL", 
        CHALLENGED: "WA", 
        SKIPPED: "SK", 
        TESTING: "CT", 
        REJECTED: "WA"
        "Partial result": "WS"
        "Perfect result": "OK"
        "Wrong answer": "WA"
        "Runtime error": "RE"

    _parseRunId: (runid) ->
        return runid.substr(1)

    _getCsrf: (page) ->
        return /<meta name="X-Csrf-Token" content="([^"]*)"/.exec(page)[1]            

    _getSourceAndResults: (runid) ->
        runid = @_parseRunId(runid)
        return await @loggedUser._getSourceAndResults(runid)
        ###
        page = await @loggedUser.download("#{@baseUrl}/submissions/#{@username}")
        csrf = @_getCsrf(page)
        formData = 
            csrf_token: csrf
            submissionId: runid
        postData =             
            formData: formData
            method: 'POST'
            followAllRedirects: true
            timeout: 30 * 1000
            maxAttempts: 1
            headers:
                "x-csrf-token": csrf
                "referer": "#{@baseUrl}/submissions/#{@username}"
        data = await @loggedUser.download "#{@baseUrl}/data/submitSource", postData
        data = JSON.parse(data)
        data.protocol = await @loggedUser.download "#{@baseUrl}/data/judgeProtocol", postData
        data.protocol = JSON.parse(data.protocol)
        return data
        ###

    correctOutcome: (outcome) ->
        parts = /([^:]*) on test \d+/.exec(outcome)
        if parts
            outcome = @VERDICTS[parts[1]] || parts[1]
        parts = /([^:]*):\s+(\d+)\s+points/.exec(outcome)
        if not parts
            return outcome
        realOutcome = @VERDICTS[parts[1]] || parts[1]
        if realOutcome == "OK"
            return "OK"
        return realOutcome + ":" + parts[2]

    getSource: (runid) ->
        try
            data = await @_getSourceAndResults(runid)
            source = data.source
            buf = Buffer.from(source, "utf8")
            source = iconv.decode(buf, "latin1")
            return normalizeCode(source)
        catch e
            logger.warn "Can't download source ", runid, e, e.stack
            throw e

    getComments: (runid) ->
        return []

    getResults: (runid) ->
        try
            data = await @_getSourceAndResults(runid)
            result = 
                compiler_output: data.protocol
                tests: []
            for i in [1..1000]
                if not ("input##{i}" of data)
                    break
                r = 
                    input: data?["input##{i}"]
                    output: data?["output##{i}"]
                    corr: data?["answer##{i}"]
                    error_output: undefined
                    checker_output: data?["checkerStdoutAndStderr##{i}"]
                    string_status: data?["verdict##{i}"]
                    time: data?["timeConsumed##{i}"]
                    max_memory_used: data?["memoryConsumed##{i}"]
                r.string_status = @VERDICTS[r.string_status] || r.string_status
                checkOutcome(r.string_status)
                result.tests.push r
            return result
        catch e
            logger.warn "Can't download results ", runid, e, e.stack
            throw e

    parseSubmits: (submits) ->
        result = []
        for submit in submits
            if submit.contestId != +@contest
                throw "Strange submit: found contest #{submit.contestId}, expected #{@contest}"
            if submit.author.members[0].handle.toLowerCase() != @username.toLowerCase()
                throw "Strange submit: found username  #{submit.author.members[0].handle}, expected #{@username}"
            if submit.problem.index != @problem
                logger.info "Skipping submit #{submit.id} because it is for a different problem: #{submit.problem.index} vs #{@problem}"
                continue
            outcome = @VERDICTS[submit.verdict] || submit.verdict || "CT"
            outcome = @correctOutcome(outcome)
            checkOutcome(outcome)
            result.push new Submit(
                _id: "c" + submit.id,
                time: new Date(submit.creationTimeSeconds * 1000),
                user: @realUser
                problem: @realProblem
                outcome: outcome
                language: submit.programmingLanguage
                testSystemData: 
                    runId: submit.id
                    contest: @contest
                    problem: @problem
                    system: "codeforces"
                    username: @username
            )
        return result

    getSubmitsFromPage: (page) ->
        if @contest.startsWith("gym")
            return @getSubmitsFromGym(page)
        COUNT_PER_PAGE = 100
        url = "#{@baseUrl}/api/contest.status?contestId=#{@contest}&handle=#{@username}&from=#{page * COUNT_PER_PAGE + 1}&count=#{COUNT_PER_PAGE}&lang=ru"
        logger.debug "apiUrl=", url
        submits = JSON.parse(await downloadLimited(url))
        if submits.status != "OK"
            return []
        result = await @parseSubmits(submits.result)
        return result

    getSubmitsFromGym: (page) ->
        if page != 0
            return []
        return await @loggedUser.getSubmitsFromGym(@contest, @problem, @realUser, @realProblem, @correctOutcome.bind(this))        ###
        url = "#{@baseUrl}/#{@contest}/my"
        page = await @loggedUser.download(url)
        document = (new JSDOM(page, {url: url})).window.document
        table = document.getElementsByClassName("status-frame-datatable")[0]
        els = table?.getElementsByTagName("tr")
        result = []
        baseProbHref = "#{@baseUrl}/#{@contest}/problem/"
        count = 0
        for el in els
            id = el.children[0]?.textContent?.trim()
            time = el.children[1]?.textContent?.trim()
            user = el.children[2]?.textContent?.trim()
            prob = el.children[3]?.getElementsByTagName("a")[0]?.href?.trim()
            lang = el.children[4]?.textContent?.trim()
            outcome = el.children[5]?.textContent?.trim()
            if (!prob || !prob.startsWith(baseProbHref))
                logger.info "Ignoring problem ", prob
                continue
            count += 1
            prob = prob.substring(baseProbHref.length)
            time = moment(time, "MMM/DD/YYYY HH:mm", true).subtract(3, 'hours').toDate()
            if outcome == "In queue" or outcome.startsWith("Running")
                outcome = "CT"
            if outcome == "Compilation error"
                outcome = "CE"
            if outcome == "Вы уже отправляли этот код"
                outcome = "DP"
            if outcome == "Accepted"
                outcome = "OK"
            if user.toLowerCase() != @username.toLowerCase()
                throw "Strange submit: found username  #{user}, expected #{@username}"
            if prob != @problem
                logger.info "Skipping submit #{id} because it is for a different problem: #{prob} vs #{@problem}"
                continue
            outcome = @correctOutcome(outcome)
            console.log "found id=#{id}, time=#{time}, user=#{user}, prob=#{prob}, lang=#{lang}, outcome=#{outcome}"
            result.push new Submit(
                _id: "c" + id,
                time: time
                user: @realUser
                problem: @realProblem
                outcome: outcome
                language: lang
                testSystemData: 
                    runId: id
                    contest: @contest
                    problem: @problem
                    system: "codeforces"
                    username: @username
            )
            checkOutcome(outcome)
        if count == 0
            notify "No submits found in CF table"
            notifyDocument page, {filename: 'page.html', contentType: "text/html"}
        return result
        ###
