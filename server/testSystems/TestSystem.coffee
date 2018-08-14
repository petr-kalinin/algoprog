export class TestSystemSubmitDownloader
    getSource: (runid) ->
        throw "not implemented"

    getComments: (runid) ->
        throw "not implemented"

    getResults: (runid) ->
        throw "not implemented"

    getSubmitsFromPage: (page) ->
        throw "not implemented"


export class TestSystemUser
    profileLink: ->
        throw "not implemented"


export default class TestSystem
    id: () ->
        throw "not implemented"

    problemLink: (problemId) ->
        throw "not implemented"

    submitsListLink: (problemId, userId) ->
        throw "not implemented"

    setOutcome: (submitId, outcome, comment) ->
        throw "not implemented"

    submitDownloader: (userId, userList, problemId, submitsPerPage) ->
        throw "not implemented"
