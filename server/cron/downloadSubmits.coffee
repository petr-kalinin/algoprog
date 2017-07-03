rp = require('request-promise-native')
import Submit from '../models/submit'
import User from '../models/user'

export class AllSubmitDownloader
    
    constructor: (@baseUrl, @userList, @submitsPerPage, @minPages, @limitPages) ->
        @addedUsers = {}
        @dirtyResults = {}
    
    AC: 'Зачтено/Принято'
    IG: 'Проигнорировано'
    DQ: 'Дисквалифицировано'
    CE: 'Ошибка компиляции'
        
    addedUsers: {}
        
    needContinueFromSubmit: (runid) ->
        true
        
    setDirty: (userId, probid) ->
        console.log "setDirty", userId, probid
        return
    
        @dirtyResults[userId + "::" + probid] = 1
        problem = Problems.findById(probid)
        if not problem
            console.log "unknown problem ", probid
            return
        for table in problem.tables
            t = table
            while true
                t = Tables.findById(t)
                if t._id == Tables.main
                    break
                @dirtyResults[userId + "::" + t._id] = 1
                t = t.parent
        @dirtyResults[userId + "::" + Tables.main] = 1

    processSubmit: (uid, name, pid, runid, prob, date, outcome) ->
        res = @needContinueFromSubmit(runid)
        if (outcome == @CE)  # completely ignore CEs
            outcome = "CE"
        if (outcome == @AC) 
            outcome = "AC"
        if (outcome == @IG) 
            outcome = "IG"
        if (outcome == @DQ) 
            outcome = "DQ"

        new Submit(
            _id: runid,
            time: date,
            user: uid,
            problem: "p" + pid,
            outcome: outcome
        ).addSubmit()
        new User(
            _id: uid,
            name: name,
            userList: @userList
        ).addUser()
        @addedUsers[uid] = uid
        @setDirty(uid, "p"+pid)
        res
    
    parseSubmits: (submitsTable, canBreak) ->
        submitsRows = submitsTable.split("<tr>")
        result = true
        wasSubmit = false
        for row in submitsRows
            re = new RegExp '<td>[^<]*</td>\\s*<td><a href="/moodle/user/view.php\\?id=(\\d+)">([^<]*)</a></td>\\s*<td><a href="/moodle/mod/statements/view3.php\\?chapterid=(\\d+)&run_id=([0-9r]+)">([^<]*)</a></td>\\s*<td>([^<]*)</td>\\s*<td>[^<]*</td>\\s*<td>([^<]*)</td>', 'gm'
            data = re.exec row
            if not data
                continue
            uid = data[1]
            name = data[2]
            pid = data[3]
            runid = data[4] + "p" + pid
            prob = data[5]
            date = data[6]
            outcome = data[7].trim()
            resultSubmit = @processSubmit(uid, name, pid, runid, prob, date, outcome)
            result = result and resultSubmit
            wasSubmit = true
            if (not result) and canBreak
                break
        return result and wasSubmit
    
    run: ->
        console.log "AllSubmitDownloader::run ", @userList, @submitsPerPage, @minPages, '-', @limitPages
        page = 0
        while true
            submitsUrl = @baseUrl(page, @submitsPerPage)
            submits = await rp submitsUrl
            submits = JSON.parse(submits)["result"]["text"]
            result = @parseSubmits(submits, page >= @minPages)
            if (page < @minPages) # always load at least minPages pages
                result = true
            if not result
                break
            page = page + 1
            if page > @limitPages
                break
            
        return
            
        tables = Tables.findAll().fetch()
        for uid,tmp of @addedUsers
            updateResults(uid, @dirtyResults)
            u = Users.findById(uid)
            u.updateChocos()
            u.updateRatingEtc()
            u.updateLevel()
        console.log "Finish AllSubmitDownloader::run ", @userList, @limitPages
            
export class LastSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        false
        #!Submits.findById(runid)

export class UntilIgnoredSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        false
        #res = Submits.findById(runid)?.outcome
        #r = !((res == "AC") || (res == "IG"))
        #return r

# Лицей 40
export lic40url = (page, submitsPerPage) ->
        'http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=5401&user_id=0&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=' + submitsPerPage + '&with_comment=&page=' + page + '&action=getHTMLTable'
        
# Заоч
export zaochUrl = (page, submitsPerPage) ->
    'http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=5402&user_id=0&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=' + submitsPerPage + '&with_comment=&page=' + page + '&action=getHTMLTable'
