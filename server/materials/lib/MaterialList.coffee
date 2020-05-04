import awaitAll from '../../../client/lib/awaitAll'
import Material from '../../models/Material'

export default class MaterialList
    constructor: (@submaterials) ->

    build: (context, properties) ->
        submaterials = await awaitAll(@submaterials.map((material) -> material.build(context)))
        material = new Material({properties..., materials: submaterials})
        await context.process(material)
        material = material.toObject()
        delete material.materials
        return material