request = require('request-promise-native')

import { JSDOM } from 'jsdom'

import Material from "../models/Material"

import logger from '../log'

url = 'http://informatics.mccme.ru/course/view.php?id=1135'

clone = (material) ->
    JSON.parse(JSON.stringify(material))

downloadAndParse = (href) ->
    jar = request.jar()
    try
        page = await request
            url: href
            jar: jar
    catch
        logger.info "Error donloading " + href + " will re-download"
        page = await request
            url: href
            jar: jar
    document = (new JSDOM(page, {url: href})).window.document
    return document

finalizeMaterialsList = (materials) ->
    materials = (m for m in materials when m)
    materials = await Promise.all(materials)
    return materials

getIndent = (activity) ->
    spacers = activity.getElementsByClassName('spacer')
    indent = 0
    for s in spacers
        indent += s.width
        s.parentElement.removeChild(s)
    if indent > 0
        indent -= 20
    return indent

getPageContent = (href) ->
    document = await downloadAndParse(href)
    data = document.getElementById("content")
    if not data
        logger.error("Can't find content for page " + href)
        return undefined

    mod = data.getElementsByClassName('modified')
    for m in mod
        m.parentElement.removeChild(m)

    return data.innerHTML

parseLink = (a, id, order, keepResourcesInTree, indent, icon, type) ->
    material = undefined
    if icon.src.endsWith("pdf.gif")
        material = new Material
            _id: id,
            order: order,
            type: "pdf",
            indent: indent
            content: a.href
            title: a.innerHTML,
            materials: []
    else if icon.src.endsWith("image.gif")
        material = new Material
            _id: id,
            order: order,
            type: "image",
            indent: indent
            content: a.href
            title: a.innerHTML,
            materials: []
    else if icon.src.endsWith("web.gif")
        material = new Material
            _id: id,
            order: order,
            type: "link",
            indent: indent
            content: a.href
            title: a.innerHTML,
            materials: []
    else
        material = new Material
            _id: id,
            order: order,
            type: type || "page",
            indent: indent
            content: await getPageContent(a.href)
            title: a.textContent,
            materials: []
    await material.upsert()
    tree = null
    if keepResourcesInTree and material.type == "page"
        tree = clone(material)
        delete tree.content
    return
        material: material
        tree: tree

makeLabelMaterial = (id, order, indent, content) ->
    material = new Material
        _id: id,
        order: order
        indent: indent
        type: "label",
        title: "",
        content: content,
        materials: []
    await material.upsert()
    return
        material: material
        tree: null

makeSpecialPage = (id, order, indent, element, keepResourcesInTree) ->
    a = element.getElementsByTagName("a")
    if a.length != 1
        logger.error("Found resource with != 1 children " + activity.innerHTML)
        return undefined
    type = "page"
    if element.classList?.contains("algoprog-epigraph")
        type = "epigraph"
    return parseLink(a[0], id, order, keepResourcesInTree, indent, {src: ""}, type)

parseLabel = (activity, order, keepResourcesInTree) ->
    indent = getIndent(activity)
    materials = []
    currentText = ""
    id = 0
    for child in activity.childNodes
        if child.classList?.contains("algoprog-page") or child.classList?.contains("algoprog-epigraph")
            if currentText
                materials.push(await makeLabelMaterial(activity.id + "_" + id, order + id, indent, currentText))
                currentText = ""
                id++
            materials.push(await makeSpecialPage(activity.id + "_" + id, order + id, indent, child, keepResourcesInTree))
            id++
        else if child.nodeType != 8  # Node.COMMENT_NODE
            currentText += child.outerHTML || child.nodeValue
    if currentText
        materials.push(await makeLabelMaterial(activity.id + "_" + id, order + id, indent, currentText))
    return materials

parseResource = (activity, order, keepResourcesInTree) ->
    indent = getIndent(activity)
    icon = activity.firstChild
    if activity.children.length != 2
        logger.error("Found resource with >2 children " + activity.innerHTML)
        return undefined
    a = activity.children[1]
    return parseLink(a, activity.id, order, keepResourcesInTree, indent, icon)

getProblem = (href, order) ->
    document = await downloadAndParse(href)
    data = document.getElementsByClassName("problem-statement")
    if not data
        logger.error("Can't find statement for problem " + href)
        return undefined

    re = new RegExp '.*view3.php\\?id=\\d+&chapterid=(\\d+)'
    res = re.exec href
    id = res[1]

    name = document.getElementsByTagName("title")[0]
    name = name.innerHTML

    re = new RegExp '^.*?\\((.*)\\)$'
    res = re.exec name
    name = res[1]
    if not name
        logger.error("Can't find name for problem " + href)
        return undefined

    text = "<h1>" + name + "</h1>"
    for tag in data
        text += "<div>" + tag.innerHTML + "</div>"

    material = new Material
        _id: "p" + id,
        order: order,
        type: "problem",
        title: name,
        content: text,
        materials: []
    await material.upsert()
    tree = clone(material)
    delete tree.content
    return
        material: material
        tree: tree

getProblemsHrefsFromStatements = (href) ->
    document = await downloadAndParse(href)
    toc = document.getElementsByClassName("statements_toc_alpha")
    if toc.length > 1
        logger.error("Found several tocs in statements " + href)
        return undefined
    toc = toc[0]

    hrefs = []
    tags = toc.getElementsByTagName("a")
    for tag in tags
        if tag.href.startsWith("http://informatics.mccme.ru/mod/statements/view3.php")
            hrefs.push(tag.href)
        else
            logger.error("Strange link in statements toc: " + tag.href + " " + href)

    return hrefs

parseStatements = (activity, order) ->
    indent = getIndent(activity)
    if activity.children.length != 2
        logger.error("Found resource with >2 children " + activity.innerHTML)
        return undefined
    a = activity.children[1]

    re = new RegExp 'view.php\\?id=(\\d+)'
    res = re.exec a.href
    id = res[1]

    hrefs = await getProblemsHrefsFromStatements(a.href)
    hrefs2 = await getProblemsHrefsFromStatements(hrefs[0])
    hrefs.splice(0, 0, hrefs2[0])

    name = a.innerHTML

    materials = []
    for href, i in hrefs
        materials.push(getProblem(href, i))

    materials = await finalizeMaterialsList(materials)
    trees = (m.tree for m in materials)
    materials = ({_id: m.material._id, title: m.material.title} for m in materials)

    material = new Material
        _id: id
        order: order
        type: "contest"
        indent: indent
        title: name
        materials: materials
    await material.upsert()

    tree = clone(material)
    delete tree.indent
    tree.materials = trees
    return
        material: material
        tree: tree

parseActivity = (activity, order, keepResourcesInTree) ->
    if activity.classList.contains("label")
        return parseLabel(activity, order, keepResourcesInTree)
    else if activity.classList.contains("resource")
        return parseResource(activity, order, keepResourcesInTree)
    else if activity.classList.contains("statements")
        return parseStatements(activity, order)
    return undefined

getLevelHeader = (material, header) ->
    if material.type != "label"
        return undefined

    re = new RegExp '\\s*<' + header + '>(Уровень\\s+(.*))</' + header + '>'
    res = re.exec material.content
    if not res
        return undefined
    id = res[2]
    name = res[1]
    return
        _id: id
        name: name

getLevel = (material) ->
    getLevelHeader(material, 'h2')

getSublevel = (material) ->
    getLevelHeader(material, 'h3')

splitLevel = (materials) ->
    levels = []
    trees = []
    currentLevel = undefined
    currentTree = undefined
    order = 0
    pendingMaterials = []
    title = ''
    for m in materials
        level = getLevel(m.material)
        if level
            # heading label
            levels.push m.material
            title = level.name
            continue
        sublevel = getSublevel(m.material)
        if sublevel
            if currentLevel
                levels.push currentLevel
                trees.push currentTree
            currentLevel = new Material
                _id: sublevel._id
                order: order
                type: "level"
                title: sublevel.name
                materials: (m.material for m in pendingMaterials)
            currentTree = clone(currentLevel)
            delete currentTree.type
            currentTree.materials = (m.tree for m in pendingMaterials when m.tree)
            order += 1
            pendingMaterials = []
        if not currentLevel
            pendingMaterials.push m
        else
            currentLevel.materials.push m.material
            if m.tree
                currentTree.materials.push m.tree
    if currentLevel
        levels.push currentLevel
        trees.push currentTree
    return
        levels: levels
        trees: trees
        title: title
        pendingMaterials: pendingMaterials

parseSection = (section, id) ->
    hidden = section.getElementsByClassName('algoprog-hidden')
    for h in hidden
        h.parentElement.removeChild(h)

    news = section.getElementsByClassName('algoprog-news')
    for h in news
        h.parentElement.removeChild(h)

    activities = section.getElementsByClassName('activity')
    materials = []

    for activity, i in activities
        parsed = parseActivity(activity, i, id==0)
        materials.push(parsed)
    materials = await finalizeMaterialsList(materials)
    materials = [].concat.apply([], materials);
    split = splitLevel(materials)
    materials = split.levels
    title = split.title
    trees = split.trees
    pendingMaterials = split.pendingMaterials

    if id == 0
        title = "Информация по курсу"

    for m in materials
        for mm in m.materials
            if mm.type == "page"
                mm.content = ""
        await m.upsert()

    material = new Material
        _id: id
        order: id
        type: "level"
        indent: 0
        title: title
        content: ""
    material.materials = (m.material for m in pendingMaterials when m.material)
    material.materials = material.materials.concat({_id: m._id, title: m.title, type: m.type, content: m.content} for m in materials)
    await material.upsert()

    tree = clone(material)
    delete tree.type
    delete tree.indent
    tree.materials = (m.tree for m in pendingMaterials when m.tree).concat(trees)
    return
        material: material
        tree: tree

export default downloadMaterials = ->
    logger.info("Start downloading materials")
    document = await downloadAndParse(url)

    materials = []

    for sectionId in [0..10]
        section = document.getElementById("section-" + sectionId)
        if not section
            continue
        materials.push(parseSection(section, sectionId))

    materials = await finalizeMaterialsList(materials)

    mainPageMaterial = new Material
        _id: "main"
        order: 0
        type: "main"
        materials: (m.material for m in materials)
    await mainPageMaterial.upsert()

    treeMaterial = new Material
        _id: "tree",
        materials: (m.tree for m in materials)
    await treeMaterial.upsert()

    logger.info("Done downloading materials")
