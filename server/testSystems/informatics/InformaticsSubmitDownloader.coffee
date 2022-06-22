moment = require('moment')
iconv = require('iconv-lite')
import { JSDOM } from 'jsdom'
Entities = require('html-entities').XmlEntities

import LANGUAGES from '../../../client/lib/languages'

import Submit from '../../models/submit'

import normalizeCode from '../../lib/normalizeCode'

import logger from '../../log'

import TestSystemSubmitDownloader, {checkOutcome} from '../TestSystem'


entities = new Entities()

EJUDGE_STATUS_TO_OUTCOME = 
    0: "OK",
    8: "AC",
    14: "CM",
    9: "IG",
    1: "CE",
    10: "DQ",
    7: "WS",
    11: "CT",
    2: "RE",
    3: "TL",
    4: "PE"
    5: "WA",
    6: "FL",
    12: "ML",
    13: "SE",
    96: "CT",
    98: "CT"
    377: "CT"
    520: "FL"

TEST_STATUS_TO_OUTCOME = 
    RT: "RE"


export default class InformaticsSubmitDownloader extends TestSystemSubmitDownloader
    constructor: (@adminUser, @baseUrl, @admin, @userId, @realUserId) ->
        super()

    parseRunId: (runid) ->
        if runid.includes("r")
            [fullMatch, contest, run] = runid.match(/(\d+)r(\d+)p(\d+)/)
        else
            [fullMatch, run] = runid.match(/(\d+)p(\d+)/)
            contest = undefined
        return [contest, run]

    getSource: (runid) ->
        try
            [contest, run] = @parseRunId(runid)
            href = "https://informatics.msk.ru/py/problem/run/#{run}/source"
            #page = await @adminUser.download(href, {encoding: 'latin1'})
            page = await @adminUser.download(href, {encoding: 'utf8'})
            logger.info "Source for run #{runid} (url #{href}): #{page}"
            source = JSON.parse(page)?.data?.source || ""
            buf = Buffer.from(source, "utf8")
            source = iconv.decode(buf, "latin1")
            return normalizeCode(source)
        catch e
            logger.warn "Can't download source ", runid, href, e.stack
            throw e

    getComments: (runid) ->
        return []

    getResults: (runid) ->
        try
            [contest, run] = @parseRunId(runid)
            if @admin
                href = "https://informatics.msk.ru/py/protocol/get-full/#{run}"
            else
                href = "https://informatics.msk.ru/py/protocol/get/#{run}"
            data = await @adminUser.download(href)
            #logger.info "results data for runid #{runid}: ", data
            result = JSON.parse(data)
            if not result.tests?[1] and not result.compiler_output and not result.message?.includes('status="SV"') and not result.message?.includes('status="CE"') and not result.protocol?.includes('compile-error="yes"')
                throw "No results found"
            for testId of result.tests
                st = result.tests[testId].status
                result.tests[testId].string_status = TEST_STATUS_TO_OUTCOME[st] || st
                checkOutcome(result.tests[testId].string_status)
            return result
        catch e
            logger.warn "Can't download results ", runid, href, e, e.stack
            throw e

    processSubmit: (uid, name, pid, runid, prob, date, language, outcome) ->
        date = new Date(moment(date))

        return new Submit(
            _id: runid,
            time: date,
            user: uid,
            problem: "p" + pid,
            outcome: outcome
            language: language
        )

    parseSubmits: (submits) ->
        console.log submits
        data = JSON.parse(submits).data
        result = true
        wasSubmit = false
        result = []
        rowI = 0
        for row in data
            rowI++
            uid = @realUserId || row.user?.id || @userId
            name = "not used"
            pid = row.problem.id
            runid = row.id + "p" + pid
            prob = row.problem.name
            date = row.create_time
            language = row.ejudge_language_id
            for key, lang of LANGUAGES
                if language == lang.informatics
                    language = key
                    break
            outcome = EJUDGE_STATUS_TO_OUTCOME[row.ejudge_status] || row.ejudge_status
            checkOutcome(outcome)
            if not outcome
                logger.warn "No outcome found `#{data[8]}`"
                continue
            result.push(@processSubmit(uid, name, pid, runid, prob, date, language, outcome))
        return result

    getSubmitsFromPage: (page) ->
        submitsUrl = @baseUrl(page)
        logger.debug "submitsUrl=", submitsUrl
        submits = await @adminUser.download submitsUrl
        if submits == ""
            return []
        result = await @parseSubmits(submits)
        return result
