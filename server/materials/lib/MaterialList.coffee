import awaitAll from '../../../client/lib/awaitAll'
import Material from '../../models/Material'

export default class MaterialList
    constructor: (@submaterials) ->

    build: (context, properties, allowAsync = false) ->
        context.pushPath(properties._id, properties.title)

        if allowAsync
            submaterials = await awaitAll(@submaterials.map((material) -> material.build(context)))
        else
            submaterials = []
            for submaterial in @submaterials
                submaterials.push(await submaterial.build(context))

        context.popPath()

        material = new Material({properties..., materials: submaterials})
        await context.process(material)

        return properties