moment = require('moment')
import { JSDOM } from 'jsdom'

import TestSystemSubmitDownloader from '../TestSystem'

import Submit from '../../models/submit'

import logger from '../../log'

export default class InformaticsSubmitDownloader extends TestSystemSubmitDownloader
    constructor: (@adminUser, @baseUrl) ->
        super()

    AC: 'Зачтено/Принято'
    IG: 'Проигнорировано'
    DQ: 'Дисквалифицировано'
    CE: 'Ошибка компиляции'
    CT: ["Тестирование...", "Компиляция...", "Перетестировать"]

    parseRunId: (runid) ->
        [fullMatch, contest, run] = runid.match(/(\d+)r(\d+)p(\d+)/)
        return [contest, run]

    getSource: (runid) ->
        try
            [contest, run] = @parseRunId(runid)
            href = "https://informatics.mccme.ru/moodle/ajax/ajax_file.php?objectName=source&contest_id=#{contest}&run_id=#{run}"
            page = await @adminUser.download(href, {encoding: 'latin1'})
            document = (new JSDOM(page)).window.document
            source = document.getElementById("source-textarea").innerHTML
            return source
        catch e
            logger.warn "Can't download source ", runid, href, e
            return ""

    getComments: (runid) ->
        try
            [contest, run] = @parseRunId(runid)
            href = "https://informatics.mccme.ru/py/comment/get/#{contest}/#{run}"
            data = await @adminUser.download(href)
            comments = JSON.parse(data).comments
            if not comments
                return []
            result = []
            for c in comments
                result.push
                    text: c.comment
                    time: new Date(moment(c.date + "+03"))
                    id: c.id
            return result
        catch e
            logger.warn "Can't download comments ", runid, href, e.stack
            return []

    getResults: (runid) ->
        try
            [contest, run] = @parseRunId(runid)
            href = "https://informatics.mccme.ru/py/protocol/get/#{contest}/#{run}"
            data = await @adminUser.download(href)
            return JSON.parse(data)
        catch
            logger.warn "Can't download results ", runid, href
            # mark so that it will not be re-downloaded
            return {failed: true}

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

        date = new Date(moment(date + "+03"))

        return new Submit(
            _id: runid,
            time: date,
            user: uid,
            problem: "p" + pid,
            outcome: outcome
            language: language
        )

    parseSubmits: (submitsTable) ->
        submitsRows = submitsTable.split("<tr>")
        result = true
        wasSubmit = false
        result = []
        rowI = 0
        for row in submitsRows
            rowI++
            ###
            <td>104-4934</td>
            <td><a href="/moodle/user/view.php?id=26405">Катя Дедович</a></td>
            <td><a href="/moodle/mod/statements/view3.php?chapterid=585&run_id=104r4934">585. Фонтан</a></td>
            <td>2018-03-23 17:12:28</td>
            <td>GNU C++ 7.2.0</td>
            <td>                <select name="5abd38fda24ee" class="round_sb" onChange="rejudgeRun(104, 4934, this)">
<option value="0" disabled>---</option>
<option value="r0"  >OK</option>
<option value="r99"  >Перетестировать</option>
<option value="r8"  >Зачтено/Принято</option>
<option value="r14"  >Ошибка оформления кода</option>
<option value="r9"  >Проигнорировано</option>
<option value="r1"  >Ошибка компиляции</option>
<option value="r10"  >Дисквалифицировано</option>
<option value="r7" selected="selected" >Частичное решение</option>
<option value="r11"  >Ожидает проверки</option>
<option value="r2"   disabled >Ошибка во время выполнения программы</option>
<option value="r3"   disabled >Превышено максимальное время работы</option>
<option value="r4"   disabled >Неправильный формат вывода</option>
<option value="r5"   disabled >Неправильный ответ</option>
<option value="r6"   disabled >Ошибка проверки,<br/>обратитесь к администраторам</option>
<option value="r12"   disabled >Превышение лимита памяти</option>
<option value="r13"   disabled >Security error</option>
<option value="r96"   disabled >Тестирование...</option>
<option value="r98"   disabled >Компилирование...</option>
</select>             </td>
            <td>6</td>
            <td>6</td>
            <td><a onclick="loadSourceWindow(104, 4934, '1');return false;" href="/moodle/ajax/ajax_file.php?objectName=source&contest_id=104&run_id=4934">Подробнее</a></td>
            ###
            re = new RegExp '<td>[^<]*</td>\\s*<td><a href="/moodle/user/view.php\\?id=(\\d+)">([^<]*)</a></td>\\s*<td><a href="/moodle/mod/statements/view3.php\\?chapterid=(\\d+)&run_id=([0-9r]+)">([^<]*)</a></td>\\s*<td>([^<]*)</td>\\s*<td>([^<]*)</td>\\s*<td>([^]*?)</td>', 'gm'
            outcomeRe = new RegExp '<option value="[^"]*" selected="selected"[^>]*>([^<]*)<', 'gm'
            data = re.exec row
            if not data
                if rowI > 2
                    logger.warn "Submit not found in line"
                continue
            uid = data[1]
            name = data[2]
            pid = data[3]
            runid = data[4] + "p" + pid
            prob = data[5]
            date = data[6]
            language = data[7]
            outcome = data[8]
            outcome = outcomeRe.exec outcome
            if not outcome
                logger.warn "No outcome found `#{data[8]}`"
                continue
            outcome = outcome[1]
            result.push(@processSubmit(uid, name, pid, runid, prob, date, language, outcome))
        return result

    getSubmitsFromPage: (page) ->
        submitsUrl = @baseUrl(page)
        logger.debug "submitsUrl=", submitsUrl
        submits = await @adminUser.download submitsUrl
        submits = JSON.parse(submits)["result"]["text"]
        result = await @parseSubmits(submits)
        return result
