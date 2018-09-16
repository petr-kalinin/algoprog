moment = require('moment')
xml2js = require('xml2js')

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
        console.log result
        return result

    _getLanguageMap: (data) ->
        result = {}
        for lang in data.runlog.languages[0].language
            result[lang.$.id] = lang.$.long_name
        console.log result
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

    getComments: () ->
        return []

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
    
