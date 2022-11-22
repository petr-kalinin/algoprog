import Material from '../models/Material'

import translate from './translate'

stripLabel = (id) ->
    idx = id.indexOf("!")
    if idx != -1
        return id.substring(0, idx)
    return undefined


export default translateProblems = () ->
    problems = await Material.findByType("problem")
    for prob in problems
        if not (prob.title?.startsWith("Name") and prob.content?.startsWith("Text"))
            continue
        console.log prob._id
        id_ru = stripLabel(prob._id)
        if not id_ru
            throw "Non-english problem " + prob._id
        prob_ru = await Material.findById(id_ru)
        res = await translate([prob_ru.title, prob_ru.content])
        [title, content] = res
        content = "<div class='alert alert-danger'>The problem statement has been automatically translated from Russian. If the statement is not clear, or you have any comments about it, please contact me. Anyway, I hope that someday I will fix the translation manually.</div>" + content
        prob.content = content
        prob.title = title
        prob.force = true
        await prob.upsert()
