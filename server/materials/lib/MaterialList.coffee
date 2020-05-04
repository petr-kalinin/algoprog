import awaitAll from '../../../client/lib/awaitAll'

clone = (material) ->
    JSON.parse(JSON.stringify(material))

export default class MaterialList
    constructor: (@submaterials) ->

    build: (context, properties, options = {}) ->
        {allowAsync = false, keepSubmaterials = false} = options
        context.pushPath(properties._id, properties.title)

        if allowAsync
            submaterials = await awaitAll(@submaterials.map((material) -> material.build(context)))
        else
            submaterials = []
            for submaterial in @submaterials
                submaterials.push(await submaterial.build(context))

        context.popPath()

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
                flattenedSubmaterials.push(ss)

        material = {properties..., materials: flattenedSubmaterials}
        await context.process(material)

        if keepSubmaterials
            properties.materials = keptSubmaterials

        return properties