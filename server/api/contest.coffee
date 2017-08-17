import Material from '../models/Material'

"
expandContest = (material) -
    res = material.toObject()
    promises = []
    for m in res.materials
        promises.push(Material.findById(m))
    res.materials = await Promise.all(promises)
    return res
"

export default contest = (id) ->
    material = await Material.findById(id)
    return material
    #return await expandMaterial(material)
