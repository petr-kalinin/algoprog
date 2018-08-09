export class TestSystemUser
    profileLink: ->
        throw "not implemented"

export default class TestSystem
    problemLink: (problemId) ->
        throw "not implemented"

    submitsListLink: (problemId, userId) ->
        throw "not implemented"

    setOutcome: (submitId, outcome, comment) ->
        throw "not implemented"

    submitDownloader: (userId, userList, problemId, submitsPerPage) ->
        throw "not implemented"
