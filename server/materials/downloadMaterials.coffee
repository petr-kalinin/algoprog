import logger from '../log'
import Material from '../models/Material'

import root from './root'


clone = (material) ->
    JSON.parse(JSON.stringify(material))


class Context
    constructor: (@processers) ->
        @pathToId = {}
        @path = []

    pushPath: (id, title) ->
        @path.push
            _id: id
            title: title

    popPath: (id) ->
        @path.pop()

    generateId: () ->
        if @path.length
            pathItem = @path[@path.length - 1]._id + "."
        else
            pathItem = ""
        if not (pathItem of @pathToId)
            @pathToId[pathItem] = 0
        @pathToId[pathItem]++
        return "#{pathItem}#{@pathToId[pathItem]}"


    process: (material) ->
        material.path = clone(@path)
        for processer in @processers
            processer.process(material)


class SaveProcesser
    process: (material) ->
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
            inProblems = true
        material.materials = newSubmaterials

        delete material.treeTitle
        await (new Material(material)).upsert()


class TreeProcesser
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
        if material.type == "label"
            return null
        if material.type.startsWith("sub.")
            return null
        if material.type == "news"
            delete material.materials
            material.type = "link"
            material.content = "/news"
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


export default downloadMaterials = () ->
    logger.info "Start downloadMaterials"
    saveProcesser = new SaveProcesser()
    treeProcesser = new TreeProcesser()
    context = new Context([saveProcesser, treeProcesser])

    await root().build(context)

    tree = treeProcesser.getTree("main")
    tree._id = "tree"
    await (new Material(tree)).upsert()
    logger.info "Done downloadMaterials"
