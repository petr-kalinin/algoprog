request = require('request-promise-native')

import Problem from "../models/problem"
import Table from "../models/table"
import User from "../models/user"

import logger from '../log'
import Informatics from '../testSystems/Informatics'
import awaitAll from '../../client/lib/awaitAll'

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
    '2019': ['41903', '41904']


class ContestDownloader
    url: 'https://informatics.msk.ru/course/view.php?id=3034'
    baseUrl: 'https://informatics.msk.ru/mod/statements/'

    constructor: ->

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
        logger.info "Downloaded contest ", name
        await new Table(
            _id: cid,
            name: name,
            problems: problemIds,
            parent: level,
            order: order*100
        ).upsert()

    getFirstProblem: (text) ->
        res = /<h4>Задача №(\d+). (.+)<\/h4>/.exec(text)
        id = res[1]
        name = res[2]
        letter = "A"
        href = "view.php?chapterid=#{id}"
        return @makeProblem(null, href, id, letter, name)

    processContest: (order, fullText, href, cid, name, level) ->
        logger.info "processContest", href, cid, name, level
        text = await @admin.download(href)

        firstProblem = @getFirstProblem(text)
        #re = new RegExp '<a href="(view3.php\\?id=\\d+&amp;chapterid=(\\d+))"><B>Задача ([^.]+)\\.</B> ([^<]*)</a>', 'gm'
        re = /<li><a title="[^"]*" class="text-truncate" href="(view.php\?id=\d+&amp;chapterid=(\d+))"><b>([^.]+)\.<\/b> ([^<]*)<\/a><\/li>/gm
        problems = []
        text.replace re, (res, a, b, c, d) =>
            problems.push(@makeProblem(res, a, b, c, d))
        problems.splice(0, 0, firstProblem);
        await @addContest(order, cid, name, level, problems)

    run: ->
        logger.info "Downloading base contests"
        @admin = await (new Informatics).getAdmin()
        text = await @admin.download(@url)
        re = /<a class="aalink" onclick="" href="(https:\/\/informatics.msk.ru\/mod\/statements\/view.php\?id=(\d+))"><img src="[^"]*statements[^"]*" [^\/]*\/><span class="instancename">(([^:]*): [^<]*)<span/gm
        order = 0
        promises = []
        text.replace re, (a,b,c,d,e) =>
            order++
            promises.push(@processContest(order,a,b,c,d,e))
        await awaitAll(promises)
        logger.info "Done downloading base contests"

class RegionContestDownloader extends ContestDownloader
    contestBaseUrl: 'https://informatics.msk.ru/mod/statements/view.php?id='

    constructor: (@contests, @prefix, @name, @name2, @order)->
        super()

    run: ->
        logger.info "Downloading #{@prefix} contests"
        @admin = await (new Informatics).getAdmin()
        levels = []
        promises = []
        for year, cont of @contests
            if cont.length == 2
                fullText = " тур #{@name2} олимпиады #{year} года"
                promises.push @processContest(@order + year * 10 + 1, '', @contestBaseUrl + cont[0], cont[0], 'Первый' + fullText, @prefix + year)
                promises.push @processContest(@order + year * 10 + 2, '', @contestBaseUrl + cont[1], cont[1], 'Второй' + fullText, @prefix + year)
            else
                fullText = "#{@name} олимпиада #{year} года"
                promises.push @processContest(@order + year * 10 + 1, '', @contestBaseUrl + cont[0], cont[0], fullText, @prefix + year)
            levels.push(@prefix + year)
        await awaitAll(promises)
        #id, name, tables, problems, parent, order
        await (new Table(
            _id: @prefix
            name: @prefix,
            tables: levels,
            parent: "main",
            order: @order
        ).upsert())
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
    await (new ContestDownloader().run())
    #(@contests, @prefix, @name, @name2, @order)
    await (new RegionContestDownloader(REGION_CONTESTS, "reg", "Региональная", "региональной", 20000).run())
    await (new RegionContestDownloader(ROI_CONTESTS, "roi", "Всероссийская", "всероссийской", 40000).run())
    await Table.removeDuplicateChildren()
    logger.info "Will update users"
    User.updateAllUsers()
    logger.info "Done downloading contests"
