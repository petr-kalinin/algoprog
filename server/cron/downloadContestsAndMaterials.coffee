request = require('request-promise-native')

import Problem from "../models/problem"
import Table from "../models/table"
import Material from "../models/Material"
import User from "../models/user"

import logger from '../log'
import download from '../lib/download'
import getTestSystem from '../testSystems/TestSystemRegistry'

clone = (material) ->
    JSON.parse(JSON.stringify(material))

class MaterialAdder
    constructor: () ->
        @materials = {}
        @contests = []
        @news = []

    addMaterial: (material) ->
        @materials[material._id] = material

    finalizeMaterialsList = (materials) ->
        materials = (m for m in materials when m)
        materials = await Promise.all(materials)
        materials = (m for m in materials when m)
        return materials

    fillPaths: (material, path) ->
        material.path = path
        path = path.concat
            _id: material._id
            title: material.title
        if not material.materials
            logger.error("Have no submaterials #{material}")
        for m in material.materials
            @fillPaths(@materials[m._id], path)

    save: ->
        promises = []
        for id, material of @materials
            promises.push(material.upsert())
        await Promise.all(promises)

    addTable: ->
        material = new Material
            _id: "table"
            type: "table",
            title: "Сводная таблица"
            content: "/table/all/main"
        @addMaterial(material)

        tree = clone(material)
        tree.type = "link"

        @contests.push
            material: material
            tree: tree

    saveNews: ->
        material = new Material
            _id: "news",
            materials: @news
            path: [{_id: "main", title: "/"}]

        await material.upsert()

    finalize: ->
        @addTable()
        @contests = await finalizeMaterialsList(@contests)

        mainPageMaterial = new Material
            _id: "main"
            order: 0
            type: "level"
            title: "/"
            materials: (m.material for m in @contests)
        @addMaterial(mainPageMaterial)

        @fillPaths(mainPageMaterial, [])
        @save()

        trees = (m.tree for m in @contests)

        treeMaterial = new Material
            _id: "tree",
            materials: trees
        await treeMaterial.upsert()

        @saveNews()

    processProblem: (problem, order) ->
        oldMaterial = await Material.findById(problem._id)
        if oldMaterial?.force
            logger.info("Will not overwrite a forced material #{problem._id}")
            material = oldMaterial
        else
            material = new Material
                _id: problem._id,
                order: order,
                type: "problem",
                title: problem.name,
                content: problem.text,
                materials: []
                isReview: problem.isReview
                
        @addMaterial(material)
        tree = clone(material)
        delete tree.content
        return
            material: material
            tree: tree

    addContest: (order, cid, name, level, problems) ->
        materials = []
        for prob, i in problems
            materials.push(@processProblem(prob, i))

        materials = await finalizeMaterialsList(materials)
        trees = (m.tree for m in materials)
        materials = ({_id: m.material._id, title: m.material.title} for m in materials)

        material = new Material
            _id: cid
            order: order
            type: "contest"
            indent: 0
            title: name
            materials: materials
        @addMaterial(material)

        tree = clone(material)
        delete tree.indent
        tree.materials = trees
        @contests.push
            material: material
            tree: tree

class ProblemsAdder
    constructor: () ->
        @problems = []
        @tables = []

    finalize: () ->
        for problem in @problems
            await problem.add()
        for table in @tables
            await table.upsert()

    addContest: (order, cid, name, level, problems) ->
        problemIds = []
        for prob, i in problems
            @problems.push new Problem(
                _id: prob._id,
                letter: prob.letter,
                name: prob.name
                isReview: prob.isReview
            )
            problemIds.push(prob._id)
        @tables.push new Table(
            _id: cid,
            name: name,
            problems: problemIds,
            parent: level,
            order: order*100
        )


class ContestDownloader
    constructor: () ->
        @adders = [new ProblemsAdder(), new MaterialAdder()]

    processContest: (order, cid, name, level, testSystem) ->
        problems = await testSystem.downloadContestProblems(cid)
        for adder in @adders
            await adder.addContest(order, cid, name, level, problems)
        logger.debug "Downloaded contest ", name

    finalize: () ->
        await Promise.all((adder.finalize() for adder in @adders))


class ShadContestDownloader extends ContestDownloader
    contests:
        "Домашнее задание 0": '1',
        "Домашнее задание 1": '2',
        "Домашнее задание 2": '3', 
        "Домашнее задание 3": '4',
        "Домашнее задание 4": '5',
        "Домашнее задание 5": '6',
        "Домашнее задание 6": '7',
        "Ревью": '9'
        "Домашнее задание 2-1": 
            id: '10',
            deadline: '2019-04-02'            
        "Домашнее задание 2-2": 
            id: '11',
            table: 'semester2',
            deadline: '2019-04-09'            

    run: ->
        levels = []
        for fullText, cont of @contests
            ejudge = getTestSystem("ejudge")
            console.log fullText, cont
            await @processContest(cont * 10 + 1, cont, fullText, "main", ejudge)

        await @finalize()

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
