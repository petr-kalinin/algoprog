moment = require('moment')
xml2js = require('xml2js')
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
    constructor: (@parameters) ->
        super()

    _getUsers: (param) ->
        data = await param.admin.download "#{param.server}/cgi-bin/new-master?action=278", {}, "new-master"
        data = JSON.parse(data)
        userMap = {}
        for user in data.data
            userMap[user.user_id] = user.user_login
        return userMap

    _getProblemMap: (data) ->
        result = {}
        for problem in data.runlog.problems[0].problem
            result[problem.$.id] = problem.$.short_name
        return result

    _getLanguageMap: (data) ->
        result = {}
        for lang in data.runlog.languages[0].language
            result[lang.$.id] = lang.$.long_name
        return result

    getSubmitsFromContest: (param) ->
        userMap = await @_getUsers(param)
        data = await param.admin.download "#{param.server}/cgi-bin/new-master?action=153", {}, "new-master"
        data = await parseXml data 
        problemMap = @_getProblemMap(data)
        languageMap = @_getLanguageMap(data)
        startTime = moment(data.runlog.$.start_time, "YYYY/MM/DD HH:mm:ss")
        results = []
        for submit in data.runlog.runs[0].run
            submit = submit.$
            results.push new Submit(
                _id: "c#{param.table}r#{submit.run_id}",
                time: startTime.add(submit.time, "minutes"),
                user: userMap[submit.user_id],
                problem: "p#{param.table}p#{problemMap[submit.prob_id]}",
                outcome: submit.status
                firstFail: if submit.status != "OK" then +submit.test + 1 else undefined
                language: languageMap[submit.lang_id]
            )
        return results

    _parseRunId: (runid) ->
        [fullMatch, contest, run] = runid.match(/c(\d+)r(\d+)/)
        return [contest, run]    

    getSource: (runid) ->
        [contest, run] = @_parseRunId(runid)
        for param in @parameters
            if param.table == contest
                return await param.admin.download "#{param.server}/cgi-bin/new-master?action=91&run_id=#{run}", {}, "new-master"
        logger.warn "Unknown contest in getSource, runid=#{runid}"
        return ""

    getComments: (runid) ->
        [contest, run] = @_parseRunId(runid)
        thisParam = undefined
        for param in @parameters
            if param.table == contest
                thisParam = param
        if not thisParam
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
                    text: pre.innerHTML
                    time: moment(time, "YYYY/MM/DD HH:mm:ss")
                    id: index
                index++
        return result

    getResults: () ->
        return {}

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
    
