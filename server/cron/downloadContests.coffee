request = require('request-promise-native')

import Problem from "../models/problem"
import Table from "../models/table"
import User from "../models/user"

import logger from '../log'
import {downloadLimited} from '../lib/download'
import awaitAll from '../../client/lib/awaitAll'
import getTestSystem from '../testSystems/TestSystemRegistry'

export REGION_CONTESTS = 
    '2009': ['894', '895']
    '2010': ['1540', '1541']
    '2011': ['2748', '2780']
    '2012': ['4345', '4361']
    '2013': ['6667', '6670']
    '2014': ['10372', '10376']
    '2015': ['14482', '14483']
    '2016': ['18805', '18806']
    '2017': ['24702', '24703']
    '2018': ['30793', '30794']
    '2019': ['40162', '40163']

export ROI_CONTESTS = 
    '2009': ['1041']
    '2010': ['1681']
    '2011': ['3102']
    '2012': ['4908']
    '2013': ['7334', '7513']
    '2014': ['11347', '11348']
    '2015': ['15255', '15256']
    '2016': ['20058', '20059']
    '2017': ['26245', '26246']
    '2018': ['32817', '32818']


class ContestDownloader
    addContest: (order, cid, name, level, problems) ->
        problemIds = []
        for prob in problems
            await new Problem(
                _id: prob._id,
                letter: prob.letter,
                name: prob.name
            ).add()
            problemIds.push(prob._id)
        logger.info "Downloaded contest ", name
        await new Table(
            _id: cid,
            name: name,
            problems: problemIds,
            parent: level,
            order: order*100
        ).upsert()

    processContest: (order, cid, name, level, testSystem) ->
        problems = await testSystem.downloadContestProblems(cid)
        idRes = idRe.exec text
        id = idRes[2]
        href = "view3.php?#{idRes[1]}"

        nameRe = new RegExp '<li><strong><B>Задача ([^.]+)\\.</B> ([^<]+)</strong></li>'
        nameRes = nameRe.exec text
        name = nameRes[2]
        letter = nameRes[1]

        return @makeProblem(nameRes[0], href, id, letter, name)

        await @addContest(order, cid, name, level, problems)

        re = new RegExp '<a title="Условия задач"\\s*href="(https://informatics.msk.ru/mod/statements/view.php\\?id=(\\d+))">(([^:]*): [^<]*)</a>', 'gm'
        logger.info "Done downloading base contests"

class ShadContestDownloader extends ContestDownloader
    contests: ['1']
        @jar = request.jar()

    run: ->
        logger.info "Downloading #{@prefix} contests"
        levels = []
        for cont, i in @contests
            fullText = "ДЗ #{cont}"
            ejudge = getTestSystem("ejudge")
            @processContest(i * 10 + 1, cont, fullText, "main", ejudge)
            else
                fullText = "#{@name} олимпиада #{year} года"
                promises.push @processContest(@order + year * 10 + 1, '', @contestBaseUrl + cont[0], cont[0], fullText, @prefix + year)
            levels.push(@prefix + year)
        await awaitAll(promises)
        logger.info "Done downloading #{@prefix} contests"

running = false

wrapRunning = (callable) ->
    () ->
        if running
            logger.info "Already running downloadContests"
            return
        try
            running = true
            await callable()
        finally
            running = false

export run = wrapRunning () ->
    logger.info "Downloading contests"
    await (new ShadContestDownloader().run())
    await (new RegionContestDownloader(REGION_CONTESTS, "reg", "Региональная", "региональной", 20000).run())
    await (new RegionContestDownloader(ROI_CONTESTS, "roi", "Всероссийская", "всероссийской", 40000).run())
    await Table.removeDuplicateChildren()
    logger.info "Will update users"
    User.updateAllUsers()
    logger.info "Done downloading contests"

###
export run = () ->
    admin = await (getTestSystem("ejudge")).getAdmin(1)
###