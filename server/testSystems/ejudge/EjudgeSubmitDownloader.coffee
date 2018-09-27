moment = require('moment')
xml2js = require('xml2js')
parseCsv = require('csv-parse/lib/sync')
import { JSDOM } from 'jsdom'

import TestSystemSubmitDownloader from '../TestSystem'

import Submit from '../../models/submit'

import logger from '../../log'

parseXml = (xml) ->
    return new Promise (resolve, reject) ->
        xml2js.parseString xml , (err, result) ->
            if err 
                reject err
            else
                resolve result


export default class EjudgeSubmitDownloader extends TestSystemSubmitDownloader
    STATUS_MAP:
        PR: "OK"
        OK: "AC"
        IG: "IG"
        WA: "Неправильный ответ"
        PT: "Неправильный ответ"
        TL: "Превышен предел времени"
        PE: "Нарушение формата выходных данных"
        RT: "Runtime error (crash)"
        ML: "Превышен предел памяти"
        DQ: "DQ"
        PD: "Тестирование..."
        CG: "Компиляция..."
        RU: "Тестирование..."

    constructor: (@parameters, @options={}) ->
        super()

    _getMaps: (param) ->
        data = await param.admin.download "#{param.server}/cgi-bin/new-master?action=153", {}, "new-master"
        data = await parseXml data
        languageMap = {}
        for lang in data.runlog.languages[0].language
            languageMap[lang.$.id] = lang.$.long_name
        problemMap = {}
        for prob in data.runlog.problems[0].problem
            problemMap[prob.$.short_name] = prob.$.id
        return {languageMap, problemMap}

    getSubmitsFromContest: (param) ->
        {languageMap, problemMap} = await @_getMaps(param)
        data = await param.admin.download "#{param.server}/cgi-bin/new-master?action=152", {}, "new-master"
        data = parseCsv data, {delimiter: ";", relax_column_count: true, columns: true}
        results = []
        for submit in data
            outcome = submit.Stat_Short
            if outcome of @STATUS_MAP
                outcome = @STATUS_MAP[outcome]
            probId = problemMap[submit.Prob]
            problem = "#{param.table}_#{probId}"
            user = submit.User_Login
            id = "#{param.table}r#{submit.Run_Id}p#{problem}"
            if @options.user and @options.user != user
                logger.debug "Ignoring submit #{id} because it is from a different user"
                continue
            if @options.problem and @options.problem != problem
                logger.debug "Ignoring submit #{id} because it is for a different problem"
                continue
            results.push new Submit(
                _id: id,
                time: new Date(submit.Time * 1000),
                user: user,
                problem: problem,
                outcome: outcome
                firstFail: if outcome != "OK" and outcome != "AC" and outcome != "IG" then +submit.Test + 1 else undefined
                language: languageMap[submit.Lang]
            )
        return results

    _parseRunId: (runid) ->
        [fullMatch, contest, run, problem] = runid.match(/(.+)r(.+)p(.+)/)
        return [contest, run, problem]

    _findParam: (contest) ->
        for param in @parameters
            if param.table == contest
                return param
        return undefined

    getSource: (runid) ->
        [contest, run] = @_parseRunId(runid)
        param = @_findParam(contest)
        if param
            return await param.admin.download "#{param.server}/cgi-bin/new-master?action=91&run_id=#{run}", {}, "new-master"
        logger.warn "Unknown contest in getSource, runid=#{runid}"
        return ""

    getComments: (runid) ->
        [contest, run] = @_parseRunId(runid)
        param = @_findParam(contest)
        if not param
            logger.warn "Unknown contest in getSource, runid=#{runid}"
            return []
        href = "#{param.server}/cgi-bin/new-master?action=36&run_id=#{run}"
        page = await param.admin.download href, {}, "new-master"
        document = (new JSDOM(page, {url: href})).window.document
        elements = document.getElementsByClassName("message-table")
        result = []
        index = 0
        for el in elements
            rows = Array.from(el.getElementsByTagName("tr"))[1..]
            for row in rows
                header = row.getElementsByClassName("profile")?[0]
                if not header
                    continue
                if header.innerHTML.match(/Run Id:/)
                    # this is a comment for previous run
                    continue
                pre = row.getElementsByTagName("pre")?[0]
                if not pre
                    continue
                time = header.innerHTML.match(/\d+\/\d+\/\d+ \d+:\d+:\d+/)
                if not time
                    continue
                result.push
                    text: pre.innerHTML.trimRight()
                    time: moment(time, "YYYY/MM/DD HH:mm:ss")
                    id: "#{runid}i#{index}"
                index++
        return result

    getResults: (runid) ->
        [contest, run] = @_parseRunId(runid)
        param = @_findParam(contest)
        href = "#{param.server}/cgi-bin/new-master?action=37&run_id=#{run}"
        page = await param.admin.download href, {}, "new-master"
        document = (new JSDOM(page, {url: href})).window.document
        result = {tests: []}
        if page.includes("Compilation error") or page.includes("Coding style violation")
            result.compiler_output = document.getElementsByTagName("pre")[0]?.textContent            
        table = document.getElementsByClassName("b1")?[0]
        if not table
            return result
        for row in table.getElementsByTagName("tr")
            td = Array.from(row.getElementsByTagName("td"))
            if not td.length
                continue
            result.tests.push
                string_status: td[1].textContent
                time:  +td[2].textContent * 1000
                max_memory_used: +td[4].textContent
        return result

    getSubmitsFromPage: (page) ->
        if page != 0
            logger.debug "Requested non-first page, returning []"
            return []
        contestResults = (@getSubmitsFromContest(param) for param in @parameters)
        contestResults = await Promise.all contestResults
        results = []
        for cr in contestResults
            results = [results..., cr...]
        return results
    
