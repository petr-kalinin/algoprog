moment = require('moment')
iconv = require('iconv-lite')
import { JSDOM } from 'jsdom'
Entities = require('html-entities').XmlEntities

import TestSystemSubmitDownloader from '../TestSystem'

import Submit from '../../models/submit'

import logger from '../../log'

import normalizeCode from '../../lib/normalizeCode'

import LANGUAGES from '../../../client/lib/languages'

entities = new Entities()


export default class CodeforcesSubmitDownloader extends TestSystemSubmitDownloader
    constructor: (@adminUser, @baseUrl, @admin) ->
        throw "Not implemented"
        super()

    AC: 'Зачтено/Принято'
    IG: 'Проигнорировано'
    DQ: 'Дисквалифицировано'
    CE: 'Ошибка компиляции'
    CT: ["Тестирование...", "Компилирование...", "Перетестировать", "Задача в очереди на тестирование"]

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
            href = "https://codeforces.msk.ru/py/problem/run/#{run}/source"
            #page = await @adminUser.download(href, {encoding: 'latin1'})
            page = await @adminUser.download(href, {encoding: 'utf8'})
            logger.info "Source for run #{runid} (url #{href}): #{page}"
            source = JSON.parse(page)?.data?.source || ""
            buf = Buffer.from(source, "utf8")
            source = iconv.decode(buf, "latin1")
            #if source.length == 0
            #    throw "Source with length 0"
            return normalizeCode(entities.decode(source))
        catch e
            logger.warn "Can't download source ", runid, href, e.stack
            throw e

    getComments: (runid) ->
        return []

    getResults: (runid) ->
        try
            [contest, run] = @parseRunId(runid)
            if @admin
                href = "https://codeforces.msk.ru/py/protocol/get-full/#{run}"
            else
                href = "https://codeforces.msk.ru/py/protocol/get/#{run}"
            data = await @adminUser.download(href)
            #logger.info "results data for runid #{runid}: ", data
            result = JSON.parse(data)
            if not result.tests?[1] and not result.compiler_output and not result.message?.includes('status="SV"') and not result.message?.includes('status="CE"') and not result.protocol?.includes('compile-error="yes"')
                throw "No results found"
            return result
        catch e
            logger.warn "Can't download results ", runid, href, e, e.stack
            throw e

    processSubmit: (uid, name, pid, runid, prob, date, language, outcome) ->
        if (outcome == @CE)
            outcome = "CE"
        if (outcome == @AC)
            outcome = "AC"
        if (outcome == @IG)
            outcome = "IG"
        if (outcome == @DQ)
            outcome = "DQ"
        if (outcome in @CT)
            outcome = "CT"

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
            uid = row.user.id
            name = row.user.firstname + " " + row.user.lastname
            pid = row.problem.id
            runid = row.id + "p" + pid
            prob = row.problem.name
            date = row.create_time
            language = row.ejudge_language_id
            for key, lang of LANGUAGES
                if language == lang.codeforces
                    language = key
                    break
            outcome = EJUDGE_STATUS_TO_OUTCOME[row.ejudge_status] || row.ejudge_status
            #outcome = outcomeRe.exec outcome
            if not outcome
                logger.warn "No outcome found `#{data[8]}`"
                continue
            #outcome = outcome[1]
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
