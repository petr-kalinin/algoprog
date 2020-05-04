import root from './root'


clone = (material) ->
    JSON.parse(JSON.stringify(material))


class BaseContext
    constructor: () ->
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


class PrintMaterialContext extends BaseContext
    process: (material) ->
        super.process(material)
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
        @trees[id] = material

    makeTree: (material) ->
        if material.type == "label"
            return null
        if material.type == "news"
            delete material.materials
        delete material.content
        delete material.force
        delete material.path
        return material

    process: (material) ->
        super.process(material)
        id = material._id
        material = clone(material)
        material.materials = (@getTree(m) for m in material.materials)
        material.materials = (m for m in material.materials when m)
        material = @makeTree(material)
        @setTree(id, material)


export default downloadMaterials = () ->

    context = new PrintMaterialContext()
    await root().build(context)
    ###
    tree = context.getTree("main")
    console.log(JSON.stringify(tree))
    ###
