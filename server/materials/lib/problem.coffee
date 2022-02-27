import { JSDOM } from 'jsdom'

import {downloadLimited} from '../../lib/download'
import ProblemModel from '../../models/problem'

import getTestSystem from '../../testSystems/TestSystemRegistry'

class Problem
    constructor: (options) ->
        if typeof options == "number"
            # informatics problem
            options = {id: options}
        @options = options
        {testSystem = "informatics", id} = options
        @testSystem = testSystem
        testSystemObject = getTestSystem(@testSystem)
        if not id
            id = testSystemObject.getProblemId(@options)
        @id = id
        @testSystemData = testSystemObject.getProblemData(@options)
        @testSystemData.system = @testSystem
        @letter = options.letter || null

    download: () ->
        testSystem = getTestSystem(@testSystem)
        return await testSystem.downloadProblem(@options)

    addContest: (contest, contests) ->
        for c in contests
            if c._id == contest._id
                c.name = contest.name
                c.contestSystem = contest.contestSystemData.system
                return contests
        contests.push({_id: contest._id, name: contest.name, contestSystem: contest.contestSystemData.system})
        return contests

    build: (idx, order, contest) ->
        id = "p#{@id}"
        material = await ProblemModel.findById(id)
        if not material
            {name, text} = await @download()
            contests = []
        else
            name = material.name
            text = material.text
            contests = material.contests
        contests = @addContest(contest, contests)
        problem = new ProblemModel
            _id: id
            name: name
            text: text
            contests: contests
            testSystemData: @testSystemData
            order: order   
            letter: @letter || String.fromCharCode('A'.charCodeAt(0) + idx)
        return problem

export default problem = (args...) -> () -> new Problem(args...)