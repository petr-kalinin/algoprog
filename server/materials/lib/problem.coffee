import { JSDOM } from 'jsdom'

import {downloadLimited} from '../../lib/download'
import Material from '../../models/Material'

import getTestSystem from '../../testSystems/TestSystemRegistry'

class Problem
    constructor: (options) ->
        if typeof options == "number"
            # informatics problem
            options = {id: options}
        @options = options
        {testSystem = "informatics", id} = options
        @testSystem = testSystem
        if not id
            testSystem = getTestSystem(@testSystem)
            id = testSystem.getProblemId(@options)
        @id = id

    download: () ->
        testSystem = getTestSystem(@testSystem)
        return await testSystem.downloadProblem(@options)

    build: (context) ->
        id = "p#{@id}"
        material = await Material.findById(id)
        if not material
            {name, text} = await @download()
        else
            name = material.title
            text = material.content
        data = 
            _id: id,
            type: "problem",
            title: name,
            content: text,

        await context.process(data)
        
        delete data.content
        return data

export default problem = (args...) -> () -> new Problem(args...)