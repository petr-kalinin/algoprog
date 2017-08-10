request = require('request-promise-native')

import Problem from "../models/problem"
import Table from "../models/table"
import User from "../models/user"

import logger from '../log'

class ContestDownloader
    url: 'http://informatics.mccme.ru/course/view.php?id=1135'
    baseUrl: 'http://informatics.mccme.ru/mod/statements/'

    constructor: ->
        @jar = request.jar()
        
    makeProblem: (fullText, href, pid, letter, name) ->
        {
            _id: "p"+pid
            letter: letter
            name: name
        }
        
    addContest: (order, cid, name, level, problems) ->
        problemIds = []
        for prob in problems
            await new Problem(
                _id: prob._id, 
                letter: prob.letter, 
                name: prob.name
            ).add()
            problemIds.push(prob._id)
        logger.debug "Downloaded contest ", name
        new Table(
            _id: cid,
            name: name,
            problems: problemIds,
            parent: level,
            order: order*100
        ).upsert()
        
    processContest: (order, fullText, href, cid, name, level) ->
        text = await request 
            url: href
            jar: @jar
        re = new RegExp '<a href="(view3.php\\?id=\\d+&amp;chapterid=(\\d+))"><B>Задача ([^.]+)\\.</B> ([^<]+)</a>'
        secondProbRes = re.exec text
        secondProbHref = secondProbRes[1].replace('&amp;','&')
        secondProb = @makeProblem(secondProbRes[0], secondProbRes[1], secondProbRes[2], secondProbRes[3], secondProbRes[4])

        text = await request 
            url: @baseUrl + secondProbHref
            jar: @jar
        re = new RegExp '<a href="(view3.php\\?id=\\d+&amp;chapterid=(\\d+))"><B>Задача ([^.]+)\\.</B> ([^<]+)</a>', 'gm'
        problems = []
        text.replace re, (res, a, b, c, d) =>
            problems.push(@makeProblem(res, a, b, c, d))
        problems.splice(1, 0, secondProb);
        @addContest(order, cid, name, level, problems)
        
    run: ->
        text = await request 
            url: @url
            jar: @jar
        re = new RegExp '<a title="Условия задач"\\s*href="(http://informatics.mccme.ru/mod/statements/view.php\\?id=(\\d+))">(([^:]*): [^<]*)</a>', 'gm'
        order = 0
        promises = []
        text.replace re, (a,b,c,d,e) => 
            order++
            promises.push(@processContest(order,a,b,c,d,e))
        Promise.all(promises)
        
class RegionContestDownloader extends ContestDownloader
    contests: 
        '2009': ['894', '895']
        '2010': ['1540', '1541']
        '2011': ['2748', '2780']
        '2012': ['4345', '4361']
        '2013': ['6667', '6670']
        '2014': ['10372', '10376']
        '2015': ['14482', '14483']
        '2016': ['18805', '18806']
        '2017': ['24702', '24703']
    
    contestBaseUrl: 'http://informatics.mccme.ru/mod/statements/view.php?id='
        
    run: ->
        levels = []
        for year, cont of @contests
            fullText = ' тур региональной олимпиады ' + year + ' года'
            @processContest(year * 10 + 1, '', @contestBaseUrl + cont[0], cont[0], 'Первый' + fullText, 'reg' + year)
            @processContest(year * 10 + 2, '', @contestBaseUrl + cont[1], cont[1], 'Второй' + fullText, 'reg' + year)
            levels.push('reg' + year)
        #id, name, tables, problems, parent, order
        await (new Table(
            _id: "reg"
            name: "reg",
            tables: levels,
            parent: "main",
            order: 200000
        ).upsert())
        users = await User.findAll()
        promises = []
        for user in users
            promises.push(User.updateUser(user._id))
        await Promise.all(promises)
        
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
    await (new ContestDownloader().run())
    await (new RegionContestDownloader().run())
    await Table.removeDuplicateChildren()
    logger.info "Done downloading contests"
