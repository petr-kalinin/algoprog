moment = require('moment')
iconv = require('iconv-lite')

import { JSDOM } from 'jsdom'

import TestSystemSubmitDownloader from '../TestSystem'

import logger from '../../log'
import download from '../../lib/download'
import normalizeCode from '../../lib/normalizeCode'
import sleep from '../../lib/sleep'
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
        FAILED: "Ошибка проверки", 
        OK: "OK", 
        PARTIAL: "Неполное решение", 
        COMPILATION_ERROR: "CE", 
        RUNTIME_ERROR: "Ошибка времени выполнения", 
        WRONG_ANSWER: "Неверный ответ", 
        PRESENTATION_ERROR: "Неправильный формат выходных данных", 
        TIME_LIMIT_EXCEEDED: "Превышен предел времени", 
        MEMORY_LIMIT_EXCEEDED: "Превышен предел памяти", 
        IDLENESS_LIMIT_EXCEEDED: "Превышен предел времени простоя", 
        SECURITY_VIOLATED: "Нарушение правил", 
        CRASHED: "Ошибка времени выполнения", 
        INPUT_PREPARATION_CRASHED: "Ошибка проверки", 
        CHALLENGED: "Взломано", 
        SKIPPED: "Пропущено", 
        TESTING: "CT", 
        REJECTED: "Отклонено"

    _parseRunId: (runid) ->
        return runid.substr(1)

    _getCsrf: (page) ->
        return /<meta name="X-Csrf-Token" content="([^"]*)"/.exec(page)[1]            

    _getSourceAndResults: (runid) ->
        runid = @_parseRunId(runid)
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
        data = await @loggedUser.download "#{@baseUrl}/data/submitSource", postData
        data = JSON.parse(data)
        data.protocol = await @loggedUser.download "#{@baseUrl}/data/judgeProtocol", postData
        data.protocol = JSON.parse(data.protocol)
        return data

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
                result.tests.push
                    input: data?["input##{i}"]
                    output: data?["output##{i}"]
                    corr: data?["answer##{i}"]
                    error_output: undefined
                    checker_output: data?["checkerStdoutAndStderr##{i}"]
                    string_status: data?["verdict##{i}"]
                    time: data?["timeConsumed##{i}"]
                    max_memory_used: data?["memoryConsumed##{i}"]
            return result
        catch e
            logger.warn "Can't download results ", runid, href, e, e.stack
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
        COUNT_PER_PAGE = 100
        url = "#{@baseUrl}/api/contest.status?contestId=#{@contest}&handle=#{@username}&from=#{page * COUNT_PER_PAGE + 1}&count=#{COUNT_PER_PAGE}&lang=ru"
        logger.debug "apiUrl=", url
        submits = JSON.parse(await downloadLimited(url))
        if submits.status != "OK"
            return []
        result = await @parseSubmits(submits.result)
        return result
