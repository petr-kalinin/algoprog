import awaitAll from '../../client/lib/awaitAll'

import logger from '../log'
import FindMistake from '../models/FindMistake'
import Material from '../models/Material'
import Problem from '../models/problem'
import Table from '../models/table'

import root from './data/root'
import rootEn from './data-en/root'


clone = (material) ->
    JSON.parse(JSON.stringify(material))

correctLabel = (label) ->
    if label != ""
        "!#{label}"
    else
        ""

dropLabel = (id) ->
    idx = id.indexOf("!")
    if idx != -1
        return id.substring(0, idx)
    return id

class Context
    constructor: (@processors, @label="") ->
        @pathToId = {}
        @path = []
        @label = correctLabel(@label)

    generateId: () ->
        if @path.length
            pathItem = @path[@path.length - 1]._id + "."
        else
            pathItem = ""
        if not (pathItem of @pathToId)
            @pathToId[pathItem] = 0
        @pathToId[pathItem]++
        return "#{pathItem}#{@pathToId[pathItem]}#{@label}"

    pushPath: (id, order, title, type) ->
        @path.push
            _id: id
            title: title
        for processor in @processors
            processor.pushPath?(id, order, title, type)

    popPath: (id) ->
        @path.pop(id)
        for processor in @processors
            processor.popPath?(id)

    process: (material) ->
        oldMaterial = await Material.findById(material._id)
        if oldMaterial?.force
            material.content = oldMaterial.content
            material.title = oldMaterial.title
            material.force = oldMaterial.force
        material = clone(material)
        material.path = clone(@path)
        for processor in @processors
            await processor.process(material)


class SaveProcessor
    constructor: () ->
        @ids = {}

    process: (material) ->
        if (material._id of @ids) and (material.type != "problem")
            throw "Duplicate material id found: #{material._id}"
        @ids[material._id] = 1
        material = clone(material)
        newSubmaterials = []
        inProblems = false
        topic = undefined
        for submaterial in material.materials || []
            if submaterial.type == "topic"
                topic = clone(submaterial)
            delete submaterial.treeTitle
            if submaterial.type != "problem" or not submaterial.sub or not topic
                newSubmaterials.push(submaterial)
                inProblems = false
                continue
            if inProblems
                continue
            newSubmaterials.push
                _id: topic._id
                title: topic.treeTitle
                type: "contest"
                sub: true
            inProblems = true
        material.materials = newSubmaterials

        delete material.treeTitle
        await (new Material(material)).upsert()

class FindMistakeProcessor
    process: (material) ->
        if material.type != "problem"
            return
        mistakes = await FindMistake.findByProblem(material._id)
        promises = []
        for fm in mistakes
            if fm.order == material.order
                continue
            fm.order = material.order
            promises.push fm.update(fm)  # do not await
        await awaitAll promises

class ContestProcessor
    constructor: () ->
        @path = []
        @contests = {}
        @problems = {}
        @tables = {}

    level: () ->
        @path[@path.length - 1]

    pushPath: (id, order, title, type) ->
        if type != "level" and type != "main"
            return
        if @level()
            @tables[@level()].tables.push(id)
        @tables[id] = new Table
            _id: id
            name: id
            tables: []
            parent: @level()
            order: order
        @path.push id

    popPath: (id) ->
        if id != @level()
            return
        @path.pop()
        if @tables[id].tables.length == 0 and @tables[id].problems.length == 0
            delete @tables[id]
            @tables[@level()].tables = @tables[@level()].tables.filter((x) -> x != id)
            
    finalize: () ->
        for id, problem of @problems
            await problem.upsert()
        for id, table of @tables
            await table.upsert()        

    process: (material) ->
        id = material._id
        if material.type == "problem"
            id = dropLabel(id)
            if not (id of @problems)
                @problems[id] = new Problem
                    _id: material._id,
                    name: material.title
                    level: ""
                    tables: []
                    testSystemData: material.testSystemData
                    order: material.order
        else if material.type == "contest" or material.type == "topic"
            problemIds = (dropLabel(m._id) for m in material.materials when m.type == "problem")
            if problemIds.length == 0
                return
            @tables[id] = new Table
                _id: id
                name: @level() + ": " + (material.treeTitle || material.title)
                problems: problemIds
                parent: @level()
                order: material.order
            for pid in problemIds
                @problems[pid].tables.push(id)
                if @problems[pid].level < @level()
                    @problems[pid].level = @level()
            @tables[@level()].tables.push(id)


class TreeProcessor
    constructor: () ->
        @trees = {}

    getTree: (material_or_id) ->
        if not (typeof material_or_id is "string")
            id = material_or_id._id
        else
            id = material_or_id
        if not (id of @trees)
            throw "Can not find material #{id} in trees"
        tree = clone(@trees[id])
        if material_or_id.treeTitle
            tree.title = material_or_id.treeTitle
        return tree

    setTree: (id, material) ->
        @trees[id] = material

    makeTree: (material) ->
        if material.type in ["label", "epigraph", "link"] and material.content != "/comments" and material.content != "/findMistakeList"
            return null
        if material.treeTitle == null
            return null
        if material.type.startsWith("sub.")
            return null
        if material.type == "news"
            delete material.materials
            material.type = "link"
            material.content = "/news"
        if material.type == "table"
            material.type = "link"
        if material.type != "link"
            delete material.content
        delete material.path
        return material

    process: (material) ->
        id = material._id
        material = clone(material)
        if material.materials
            material.materials = (@getTree(m) for m in material.materials || [] when not m.sub)
            material.materials = (m for m in material.materials when m)
        material = @makeTree(material)
        @setTree(id, material)


downloadRussian = (processors) ->
    treeProcessor = new TreeProcessor()
    context = new Context(processors.concat(treeProcessor))

    await root()().build(context)

    tree = treeProcessor.getTree("main")
    tree._id = "tree"
    await (new Material(tree)).upsert()

downloadEnglish = (processors) ->
    treeProcessor = new TreeProcessor()
    context = new Context(processors.concat(treeProcessor), "en")

    await rootEn()().build(context)

    tree = treeProcessor.getTree("main!en")
    tree._id = "tree!en"
    await (new Material(tree)).upsert()


export default downloadMaterials = () ->
    contestProcessor = new ContestProcessor()
    processors = [new SaveProcessor(),
        contestProcessor,
        new FindMistakeProcessor()]

    logger.info "Start downloadMaterials"
    await downloadRussian(processors)
    await downloadEnglish(processors)
    await contestProcessor.finalize()
    logger.info "Done downloadMaterials"

