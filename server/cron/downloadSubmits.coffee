request = require('request-promise-native')
deepEqual = require('deep-equal')
moment = require('moment')
import { JSDOM } from 'jsdom'

import Submit from '../models/submit'
import SubmitComment from '../models/SubmitComment'
import User from '../models/user'
import RegisteredUser from '../models/registeredUser'
import Problem from '../models/problem'
import Table from '../models/table'
import InformaticsUser from '../informatics/InformaticsUser'

import logger from '../log'
import download from '../lib/download'

import * as groups from '../informatics/informaticsGroups'
import { REGISTRY as testSystemsRegistry } from '../testSystems/TestSystemRegistry'

class SubmitDownloader
    constructor: (@baseDownloader, @minPages, @limitPages, @forceMetadata) ->
        @dirtyUsers = {}
        @dirtyResults = {}

    needContinueFromSubmit: (submit) ->
        true

    setDirty: (submit) ->
        userId = submit.user
        probId = submit.problem
        @dirtyUsers[userId] = 1
        @dirtyResults[userId + "::" + probId] = 1
        problem = await Problem.findById(probId)
        if not problem
            return
        for table in problem.tables
            t = table
            while true
                t = await Table.findById(t)
                if t._id == Table.main
                    break
                @dirtyResults[userId + "::" + t._id] = 1
                t = t.parent
        @dirtyResults[userId + "::" + Table.main] = 1

    upsertComments: (submit, comments) ->
        for c in comments
            problem = await Problem.findById(submit.problem)
            newComment = new SubmitComment
                _id: c.id
                problemId: submit.problem
                problemName: problem.name
                userId: submit.user
                text: c.text
                time: c.time
                outcome: submit.outcome
            await newComment.upsert()

    mergeComments: (c1, c2) ->
        result = c1
        for c in c2
            if not (c in result)
                result.push(c)
        return result

    processSubmit: (newSubmit) ->
        logger.debug "Found submit ", newSubmit._id, newSubmit.user, newSubmit.problem
        res = await @needContinueFromSubmit(newSubmit)

        oldSubmit = (await Submit.findById(newSubmit._id))?.toObject()

        if oldSubmit
            newSubmit.source = oldSubmit.source
            newSubmit.results = oldSubmit.results
            newSubmit.comments = oldSubmit.comments
            newSubmit.quality = oldSubmit.quality
        if (oldSubmit and newSubmit and deepEqual(oldSubmit, newSubmit.toObject()) \
                and oldSubmit.results \
                and not @forceMetadata)
            logger.debug "Submit already in the database #{newSubmit._id}"
            return res

        if oldSubmit?.force and not @forceMetadata
            logger.info("Will not overwrite a forced submit #{newSubmit._id}")
            await @setDirty(newSubmit)
            return res

        if oldSubmit?.force
            newSubmit.outcome = oldSubmit.outcome
            newSubmit.force = oldSubmit.force

        [source, comments, results] = await Promise.all([
            @baseDownloader.getSource(newSubmit._id),
            @baseDownloader.getComments(newSubmit._id),
            @baseDownloader.getResults(newSubmit._id)
        ])

        @upsertComments(newSubmit, comments)
        comments = (c.text for c in comments)

        newSubmit.source = source
        newSubmit.results = results
        newSubmit.comments = @mergeComments(newSubmit.comments, comments)

        logger.debug "Adding submit", newSubmit._id, newSubmit.user, newSubmit.problem
        try
            await newSubmit.upsert()
        catch e
            logger.warning "Could not upsert submit", newSubmit._id, newSubmit.user, newSubmit.problem, e
        await @setDirty(newSubmit)
        logger.debug "Done submit", newSubmit._id, newSubmit.user, newSubmit.problem
        res

    processDirty: (uid) ->
        User.updateUser(uid, @dirtyResults)

    run: ->
        logger.info "SubmitDownloader.run ", @minPages, '-', @limitPages

        page = 0
        while true
            logger.info("Dowloading submits, page #{page}")
            submits = await @baseDownloader.getSubmitsFromPage(page)
            if not submits.length
                break
            results = await Promise.all(@processSubmit(submit) for submit in submits)
            needContinue = true
            for r in results
                needContinue = needContinue and r
            if (page < @minPages - 1) # always load at least minPages pages
                needContinue = true
            if not needContinue
                break
            page = page + 1
            if page > @limitPages
                break

        tables = await Table.find({})
        addedPromises = []
        for uid, tmp of @dirtyUsers
            logger.debug "Will process dirty user ", uid
            addedPromises.push(@processDirty(uid))
        await Promise.all(addedPromises)
        logger.info "Finish SubmitDownloader.run ", @minPages, '-', @limitPages

class LastSubmitDownloader extends SubmitDownloader
    needContinueFromSubmit: (submit) ->
        !await Submit.findById(submit._id)

class UntilIgnoredSubmitDownloader extends SubmitDownloader
    needContinueFromSubmit: (submit) ->
        res = (await Submit.findById(submit._id))?.outcome
        r = !((res == "AC") || (res == "IG"))
        return r


running = false

wrapRunning = (callable) ->
    () ->
        if running
            logger.info "Already running downloadSubmits"
            return
        try
            running = true
            await callable()
        finally
            running = false

forAllTestSystems = (callable) ->
    for _, system of testSystemsRegistry
        await callable(system)


# (@baseDownloader, @minPages, @limitPages, @forceMetadata)
# submitDownloader: (userId, problemId, submitsPerPage) ->

export runForUser = (userId, submitsPerPage, maxPages) ->
    try
        user = await User.findById(userId)
        await forAllTestSystems (system) ->
            logger.info "runForUser", system.id(), userId
            systemDownloader = await system.submitDownloader(userId, undefined, submitsPerPage)
            await (new SubmitDownloader(systemDownloader, 1, maxPages, true)).run()
            logger.info "Done runForUser", system.id()
    catch e
        logger.error "Error in runForUser", e

export runForUserAndProblem = (userId, problemId) ->
    try
        user = await User.findById(userId)
        await forAllTestSystems (system) ->
            logger.info "runForUserAndProblem", system.id(), userId, problemId
            systemDownloader = await system.submitDownloader(userId, problemId, 100)
            await (new SubmitDownloader(systemDownloader, 1, 10, true)).run()
            logger.info "Done runForUserAndProblem", system.id(), userId, problemId
    catch e
        logger.error "Error in runForUserAndProblem", e


export runAll = wrapRunning () ->
    try
        await forAllTestSystems (system) ->
            logger.info "runAll", system.id()
            systemDownloader = await system.submitDownloader(undefined, undefined, 1000)
            await (new SubmitDownloader(systemDownloader, 1, 1e9, false)).run()
            logger.info "Done runAll", system.id()
    catch e
        logger.error "Error in SubmitDownloader", e

export runUntilIgnored = wrapRunning () ->
    try
        await forAllTestSystems (system) ->
            logger.info "runUntilIgnored", system.id()
            systemDownloader = await system.submitDownloader(undefined, undefined, 1000)
            await (new UntilIgnoredSubmitDownloader(systemDownloader, 1, 1e9, false)).run()
            logger.info "Done runUntilIgnored", system.id()
    catch e
        logger.error "Error in UntilIgnoredSubmitDownloader", e

export runLast = wrapRunning () ->
    try
        await forAllTestSystems (system) ->
            logger.info "runLast", system.id()
            systemDownloader = await system.submitDownloader(undefined, undefined, 100)
            await (new LastSubmitDownloader(systemDownloader, 1, 100, false)).run()
            logger.info "Done runLast", system.id()
    catch e
        logger.error "Error in LastSubmitDownloader", e
