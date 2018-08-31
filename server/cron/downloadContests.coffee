request = require('request-promise-native')

import Problem from "../models/problem"
import Table from "../models/table"
import User from "../models/user"

import logger from '../log'
import download from '../lib/download'
import getTestSystem from '../testSystems/TestSystemRegistry'

class ContestDownloader
    addContest: (order, cid, name, level, problems) ->
        problemIds = []
        for prob in problems
            await new Problem(
                _id: prob._id,
                letter: prob.letter,
                name: prob.name
            ).add()
            problemIds.push(prob._id)
        logger.debug "Downloaded contest ", name
        new Table(
            _id: cid,
            name: name,
            problems: problemIds,
            parent: level,
            order: order*100
        ).upsert()

    processContest: (order, cid, name, level, testSystem) ->
        problems = await testSystem.downloadContestProblems(cid)
        @addContest(order, cid, name, level, problems)


class ShadContestDownloader extends ContestDownloader
    contests: ['1']

    run: ->
        levels = []
        for cont, i in @contests
            fullText = "ДЗ #{cont}"
            ejudge = getTestSystem("ejudge")
            @processContest(i * 10 + 1, cont, fullText, "main", ejudge)
        users = await User.findAll()
        promises = []
        for user in users
            promises.push(User.updateUser(user._id))
        await Promise.all(promises)

running = false

wrapRunning = (callable) ->
    () ->
        if running
            logger.info "Already running downloadContests"
            return
        try
            running = true
            await callable()
        finally
            running = false

export run = wrapRunning () ->
    logger.info "Downloading contests"
    await (new ShadContestDownloader().run())
    await Table.removeDuplicateChildren()
    logger.info "Done downloading contests"

###
export run = () ->
    admin = await (getTestSystem("ejudge")).getAdmin(1)
###