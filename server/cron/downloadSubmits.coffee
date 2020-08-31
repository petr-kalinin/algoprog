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

import awaitAll from '../../client/lib/awaitAll'

import * as groups from '../informatics/informaticsGroups'
import getTestSystem, { REGISTRY as testSystemsRegistry } from '../testSystems/TestSystemRegistry'

entities = new Entities()

compare = (a, b, path) ->
    if a and typeof a == 'object' and b and typeof b == 'object'
        seen = {}
        for own key of a
            compare(a[key], b[key], path + "." + key)
            seen[key] = 1
        for own key of b
            if not (key of seen)
                compare(a[key], b[key], path + "." + key)
    else if a != b
        console.log "Diff: #{path} #{a} #{b}"

class SubmitDownloader
    constructor: (@baseDownloader, @minPages, @limitPages, @forceMetadata, @onNewSubmit, @system) ->
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
        logger.info "Found submit ", newSubmit._id, newSubmit.user, newSubmit.problem, newSubmit.outcome
        if not newSubmit.testSystemData
            newSubmit.testSystemData = {}
        newSubmit.testSystemData.system = @system
        res = await @needContinueFromSubmit(newSubmit)

        oldSubmit = (await Submit.findById(newSubmit._id))?.toObject()

        if oldSubmit
            delete oldSubmit.__v
            newSubmit.userList = oldSubmit.userList
            newSubmit.source = oldSubmit.source
            newSubmit.sourceRaw = oldSubmit.sourceRaw
            newSubmit.results = oldSubmit.results
            newSubmit.comments = oldSubmit.comments
            newSubmit.quality = oldSubmit.quality
            newSubmit.language = oldSubmit.language
            newSubmit.downloadTime = oldSubmit.downloadTime
            newSubmit.hashes = oldSubmit.hashes
            newSubmit.testSystemData = {oldSubmit.testSystemData..., newSubmit.testSystemData...}
            newSubmit.findMistake = oldSubmit.findMistake
        if (oldSubmit and newSubmit and deepEqual(oldSubmit, newSubmit.toObject()) \
                and oldSubmit.results \
                and oldSubmit.source != "" \
                and not @forceMetadata)
            await @onNewSubmit?(newSubmit)
            logger.info "Submit already in the database #{newSubmit._id}"
            return res

        if oldSubmit?.force and not @forceMetadata
            await @onNewSubmit?(newSubmit)
            logger.info("Will not overwrite a forced submit #{newSubmit._id}")
            await @setDirty(newSubmit)
            return res

        if oldSubmit?.force
            newSubmit.outcome = oldSubmit.outcome
            newSubmit.force = oldSubmit.force

        try
            sourceRaw = await @baseDownloader.getSource(newSubmit._id)
            results = await @baseDownloader.getResults(newSubmit._id)
            comments = []
        catch e
            if newSubmit.outcome != "CT"
                throw e
            logger.info "Can't download some data, but submit is CT, that's ok"
                
        sourceRaw = sourceRaw or ""
        comments = comments or []
        results = results or {}
        
        source = entities.encode(sourceRaw.toString())

        @upsertComments(newSubmit, comments)
        comments = (c.text for c in comments)

        newSubmit.source = source
        newSubmit.sourceRaw = sourceRaw
        newSubmit.results = results
        newSubmit.comments = @mergeComments(newSubmit.comments, comments)
        newSubmit.downloadTime = new Date()
        await newSubmit.calculateHashes()

        user = await User.findById(newSubmit.user)
        if user?.userList == "graduated" and newSubmit.outcome == "OK" and newSubmit.time > new Date(2020, 1, 28)
            newSubmit.outcome = "AC"
            newSubmit.force = true

        if not newSubmit?.userList then newSubmit.userList = user?.userList

        await @onNewSubmit?(newSubmit)
        logger.debug "Adding submit", newSubmit._id, newSubmit.user, newSubmit.problem, newSubmit.findMistake
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
                results = await awaitAll(@processSubmit(submit) for submit in submits)
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
            await awaitAll(addedPromises)
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


export runForUserAndProblem = (userId, problemId, onNewSubmit, forceMetadata) ->
    try
        registeredUser = await RegisteredUser.findByKeyWithPassword(userId)
        problem = await Problem.findById(problemId)
        system = getTestSystem(problem.testSystemData.system)
        logger.info "runForUserAndProblem", system.id(), userId, problemId
        systemDownloader = await system.submitDownloader(registeredUser, problem, 100)
        await (new SubmitDownloader(systemDownloader, 1, 10, forceMetadata, onNewSubmit, problem.testSystemData.system)).run()
        logger.info "Done runForUserAndProblem", system.id(), userId, problemId
    catch e
        logger.error "Error in runForUserAndProblem", e

export runForCT = wrapRunning () ->
    try
        submits = await Submit.findCT()
        data = []
        for submit in submits
            timeSinceSubmit = new Date() - submit.time
            timeSinceDownload = new Date() - submit.downloadTime
            if (timeSinceSubmit > 2 * 60 * 1000 and timeSinceDownload < 30 * 1000)
                continue
            if (timeSinceSubmit > 10 * 60 * 1000 and timeSinceDownload < 20 * 60 * 1000)
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
        await awaitAll(data.map((d) -> runForUserAndProblem(d.userId, d.problemId)))
    catch e
        logger.error "Error in LastSubmitDownloader", e
