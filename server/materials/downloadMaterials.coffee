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
        await material.upsert()


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
        return clone(@trees[id])

    setTree: (id, material) ->
        console.log "setTree", id, material
        @trees[id] = material

    makeTree: (material) ->
        if material.type == "label"
            return null
        if material.type.startsWith("sub.")
            return null
        delete material.content
        delete material.force
        delete material.path
        if material.type == "news"
            delete material.materials
            material.type = "link"
            material.content = "/news"
        return material

    process: (material) ->
        id = material._id
        material = clone(material)
        material.materials = (@getTree(m) for m in material.materials when not m.sub)
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
