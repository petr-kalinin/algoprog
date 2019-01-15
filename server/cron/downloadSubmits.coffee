request = require('request-promise-native')
deepEqual = require('deep-equal')
moment = require('moment')
import { JSDOM } from 'jsdom'
Entities = require('html-entities').XmlEntities

import Submit from '../models/submit'
import SubmitComment from '../models/SubmitComment'
import User from '../models/user'
import RegisteredUser from '../models/registeredUser'
import Problem from '../models/problem'
import Table from '../models/table'
import InformaticsUser from '../informatics/InformaticsUser'

import logger from '../log'
import download from '../lib/download'
import setDirty from '../lib/setDirty'

import * as groups from '../informatics/informaticsGroups'
import { REGISTRY as testSystemsRegistry } from '../testSystems/TestSystemRegistry'

entities = new Entities()

class SubmitDownloader
    constructor: (@baseDownloader, @minPages, @limitPages, @forceMetadata) ->
        @dirtyUsers = {}
        @dirtyResults = {}

    needContinueFromSubmit: (submit) ->
        true

    setDirty: (submit) ->
        await setDirty(submit, @dirtyResults, @dirtyUsers)

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
            delete oldSubmit.__v
            newSubmit.source = oldSubmit.source
            newSubmit.sourceRaw = oldSubmit.sourceRaw
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

        [sourceRaw, comments, results] = await Promise.all([
            @baseDownloader.getSource(newSubmit._id),
            @baseDownloader.getComments(newSubmit._id),
            @baseDownloader.getResults(newSubmit._id)
        ])
        source = entities.encode(sourceRaw.toString())

        @upsertComments(newSubmit, comments)
        comments = (c.text for c in comments)

        newSubmit.source = source
        newSubmit.sourceRaw = sourceRaw
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
        
        try
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
                if (page < @minPages - 1)  # always load at least minPages pages
                    needContinue = true
                if not needContinue
                    break
                page = page + 1
                if page > @limitPages
                    break
        finally
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
            systemDownloader = await system.submitDownloader(userId, undefined, undefined, submitsPerPage)
            await (new SubmitDownloader(systemDownloader, 1, maxPages, false)).run()
            logger.info "Done runForUser", system.id()
    catch e
        logger.error "Error in runForUser", e

export runForUserAndProblem = (userId, problemId) ->
    try
        user = await User.findById(userId)
        await forAllTestSystems (system) ->
            logger.info "runForUserAndProblem", system.id(), userId, problemId
            systemDownloader = await system.submitDownloader(userId, problemId, undefined, 100)
            await (new SubmitDownloader(systemDownloader, 1, 10, false)).run()
            logger.info "Done runForUserAndProblem", system.id(), userId, problemId
    catch e
        logger.error "Error in runForUserAndProblem", e


export runAll = wrapRunning () ->
    try
        await forAllTestSystems (system) ->
            logger.info "runAll", system.id()
            systemDownloader = await system.submitDownloader(undefined, undefined, undefined, 1000)
            await (new SubmitDownloader(systemDownloader, 1, 1e9, false)).run()
            logger.info "Done runAll", system.id()
    catch e
        logger.error "Error in SubmitDownloader", e

export runUntilIgnored = wrapRunning () ->
    try
        await forAllTestSystems (system) ->
            logger.info "runUntilIgnored", system.id()
            systemDownloader = await system.submitDownloader(undefined, undefined, undefined, 1000)
            await (new UntilIgnoredSubmitDownloader(systemDownloader, 1, 1e9, false)).run()
            logger.info "Done runUntilIgnored", system.id()
    catch e
        logger.error "Error in UntilIgnoredSubmitDownloader", e

export runLast = wrapRunning () ->
    try
        lastSubmit = await Submit.findLastNotCT()
        fromTimestamp = (+lastSubmit.time) / 1000 - 5 * 60
        logger.info "fromTimestamp=#{fromTimestamp}"
        await forAllTestSystems (system) ->
            logger.info "runLast", system.id()
            systemDownloader = await system.submitDownloader(undefined, undefined, fromTimestamp, 100)
            await (new LastSubmitDownloader(systemDownloader, 1, 100, false)).run()
            logger.info "Done runLast", system.id()
    catch e
        logger.error "Error in LastSubmitDownloader", e

export runForCT = wrapRunning () ->
    try
        submits = await Submit.findCT()
        data = []
        for submit in submits
            timeSinceSubmit = new Date() - submit.time
            timeSinceDownload = new Date() - submit.downloadTime
            if (timeSinceSubmit > 20 * 60 * 1000 and timeSinceDownload < 20 * 60 * 1000)
                continue
            submit.downloadTime = new Date()
            await submit.upsert()

            userId = submit.user
            problemId = submit.problem
            unique = true
            for d in data
                if d.userId == userId and d.problemId == problemId
                    unique = false
                    break
            if unique
                data.push {userId, problemId}
        await Promise.all(data.map((d) -> runForUserAndProblem(d.userId, d.problemId)))
    catch e
        logger.error "Error in LastSubmitDownloader", e
