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

    submitDownloader: (userId, problemId, fromTimestamp, submitsPerPage, testSystemData) ->
        throw "not implemented"

    submitNeedsFormData: () ->
        throw "not implemented"
    
    submitWithFormData: (userId, problemId, contentType, data) ->
        throw "not implemented"

    submitWithObject: (user, problemId, data) ->
        throw "not implemented"

    registerUser: (user) ->
        throw "not implemented"

    selfTest: () ->
        throw "not implemented"

    downloadProblem: (options) ->
        throw "not implemented"

    getProblemId: (options) ->
        throw "not implemented"

    getProblemData: (options) ->
        throw "not implemented"
