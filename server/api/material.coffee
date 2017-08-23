import Material from '../models/Material'

expandLevel = (material) ->
    res = material.toObject()
    promises = []
    for m in res.materials
        promises.push(Material.findById(m))
    res.materials = await Promise.all(promises)
    return res

export default material = (id) ->
    material = await Material.findById(id)
    if material.type == "level"
        material = await expandLevel(material)
    return material
