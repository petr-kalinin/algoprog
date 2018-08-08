import TestSystem, {TestSystemUser} from './TestSystem'

class InformaticsUser extends TestSystemUser
    constructor: (@id) ->

    profileLink: () ->
        "https://informatics.mccme.ru/user/view.php?id=#{@id}&course=1"

class Informatics extends TestSystem
    BASE_URL = "https://informatics.mccme.ru"

    _informaticsProblemId: (problemId) ->
        problemId.substring(1)

    _getAdmin: () ->
        throw "not implemented"

    problemLink: (problemId) ->
        id = @_informaticsProblemId(problemId)
        "#{BASE_URL}/moodle/mod/statements/view3.php?chapterid=#{id}"

    submitListLink: (problemId, userId) ->
        id = @_informaticsProblemId(problemId)
        "#{BASE_URL}/moodle/mod/statements/view3.php?" + "chapterid=#{id}&submit&user_id=#{userId}"

    setOutcome: (submitId, outcome, comment) ->
        adminUser = await _getAdmin()
        [fullSubmitId, contest, run, problem] = submitId.match(/(\d+)r(\d+)p(\d+)/)
        outcomeCode = switch outcome
            when "AC" then 8
            when "IG" then 9
            when "DQ" then 10
            else undefined
            
        try
            if outcomeCode
                href = "#{BASE_URL}/py/run/rejudge/#{contest}/#{run}/#{outcomeCode}"
                await adminUser.download(href, {maxAttempts: 1})
        finally
            if req.body.comment
                href = "#{BASE_URL}/py/comment/add"
                body =
                    run_id: run
                    contest_id: contest
                    comment: req.body.comment
                    lines: ""
                await adminUser.download(href, {
                    method: 'POST',
                    headers: {'Content-Type': "application/x-www-form-urlencoded; charset=UTF-8"},
                    form: body,
                    followAllRedirects: true
                    maxAttempts: 1
                })

