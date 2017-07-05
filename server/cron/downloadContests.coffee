request = require('request-promise-native')

import Problem from "../models/problem"
import Table from "../models/table"

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
        new Table(
            _id: cid,
            name: name,
            problems: [],
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
        text.replace re, (a,b,c,d,e) => 
            order++
            @processContest(order,a,b,c,d,e)
        
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
    
    contestBaseUrl: 'http://informatics.mccme.ru/mod/statements/view.php?id='
        
    run: ->
        levels = []
        for year, cont of @contests
            fullText = ' тур региональной олимпиады ' + year + ' года'
            @processContest('', @contestBaseUrl + cont[0], cont[0], 'Первый' + fullText, 'reg' + year)
            @processContest('', @contestBaseUrl + cont[1], cont[1], 'Второй' + fullText, 'reg' + year)
            levels.push('reg' + year)
        #id, name, tables, problems, parent, order
        Tables.addTable("reg", "reg", levels, [], "main", 10000)
        #table = Tables.findById("reg")
        #users = Users.findAll().fetch()
        #for user in users
        #    Results.updateResults(user, table)

export run = () ->
    new ContestDownloader().run()
    #new RegionContestDownloader().run()
