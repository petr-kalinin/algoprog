import awaitAll from '../../../client/lib/awaitAll'

clone = (material) ->
    JSON.parse(JSON.stringify(material))

makeOrder = (order, i) ->
    "#{order}.#{(""+i).padStart(3, 0)}"

export default class MaterialList
    constructor: (@submaterials) ->

    build: (context, order, properties, options = {}) ->
        {allowAsync = false, keepSubmaterials = false} = options
        context.pushPath(properties._id, order, properties.title, properties.type)

        @submaterials = (s for s in @submaterials when s)
        if allowAsync
            submaterials = await awaitAll(@submaterials.map((material, i) -> material().build(context, makeOrder(order, i))))
        else
            submaterials = []
            for submaterial, i in @submaterials
                submaterials.push(await submaterial().build(context, makeOrder(order, i)))

        context.popPath(properties._id)

        flattenedSubmaterials = []
        keptSubmaterials = []
        for submaterial in submaterials
            sm = clone(submaterial)
            delete sm.materials
            keptSubmaterials.push(sm)
            flattenedSubmaterials.push(sm)
            for ss in submaterial.materials || []
                if ss.materials
                    throw "Nested materials in " + submaterials
                ss = clone(ss)
                ss.sub = true
                if ss.type == "topic" or sm.type == "topic"
                    flattenedSubmaterials.push(ss)

        material = {properties..., order, materials: flattenedSubmaterials}
        await context.process(material)

        if keepSubmaterials
            properties.materials = keptSubmaterials

        return properties