import awaitAll from '../../../client/lib/awaitAll'
import Material from '../../models/Material'

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
        keepSubmaterials = []
        for submaterial in submaterials
            sm = clone(submaterial)
            delete sm.materials
            flattenedSubmaterials.push(sm)
            keepSubmaterials.push(sm)
            for ss in submaterial.materials || []
                if ss.materials
                    throw "Nested materials in " + submaterials
                flattenedSubmaterials.push(clone(ss))

        material = new Material({properties..., materials: flattenedSubmaterials})
        await context.process(material)

        if keepSubmaterials
            properties.materials = keepSubmaterials

        return properties