import Material from '../models/Material'

expandMaterial = (material) ->
    res = material.toObject()
    promises = []
    for m in res.materials
        promises.push(Material.findById(m))
    res.materials = await Promise.all(promises)
    return res

export default level = (id) ->
    material = await Material.findById(id)
    return await expandMaterial(material)
