export class TestSystemSubmitDownloader
    getSource: (runid) ->
        throw "not implemented: getSource"

    getComments: (runid) ->
        throw "not implemented: getComments"

    getResults: (runid) ->
        throw "not implemented: getResults"

    getSubmitsFromPage: (page) ->
        throw "not implemented: getSubmitsFromPage"


export class TestSystemUser
    profileLink: ->
        throw "not implemented: profileLink"


export default class TestSystem
    id: () ->
        throw "not implemented: id"

    problemLink: (problemId) ->
        throw "not implemented: problemLink"

    submitsListLink: (problemId, userId) ->
        throw "not implemented: submitsListLink"

    submitDownloader: (userId, problemId, fromTimestamp, submitsPerPage) ->
        throw "not implemented: submitDownloader"

    submitNeedsFormData: () ->
        throw "not implemented: submitNeedsFormData"
    
    submitWithFormData: (userId, problemId, contentType, data) ->
        throw "not implemented: submitWithFormData"

    submitWithObject: (user, problemId, data) ->
        throw "not implemented: submitWithObject"

    registerUser: (user) ->
        throw "not implemented: registerUser"

    selfTest: () ->
        throw "not implemented: selfTest"

    downloadContestProblems: (contestId) ->
        throw "not implemented: downloadContestProblems"
