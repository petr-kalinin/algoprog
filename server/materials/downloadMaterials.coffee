import root from './root'


clone = (material) ->
    JSON.parse(JSON.stringify(material))


class BaseContext
    constructor: () ->
        @levelToId = {}
        @levelStack = [""]

    pushLevel: (id) ->
        @levelStack.push id

    popLevel: (id) ->
        @levelStack.pop()

    generateId: () ->
        level = @levelStack[@levelStack.length - 1]
        if not (level of @levelToId)
            @levelToId[level] = 0
        @levelToId[level]++
        return "#{level}.#{@levelToId[level]}"


class PrintMaterialContext extends BaseContext
    process: (material) ->
        console.log "Have material ", material


class TreeContext extends BaseContext
    constructor: () ->
        super(constructor)
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
        console.log material
        @trees[id] = material

    makeTree: (material) ->
        if material.type == "label"
            return null
        delete material.content
        delete material.force
        delete material.path
        return material

    process: (material) ->
        id = material._id
        material = clone(material)
        material.materials = (@getTree(m) for m in material.materials)
        material.materials = (m for m in material.materials when m)
        material = @makeTree(material)
        @setTree(id, material)


export default downloadMaterials = () ->
    context = new TreeContext()
    await root().build(context)
    tree = context.getTree("main")
    console.log(JSON.stringify(tree))
