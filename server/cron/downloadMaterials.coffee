request = require('request-promise-native')

import { JSDOM } from 'jsdom'

import Material from "../models/Material"

import logger from '../log'

url = 'http://informatics.mccme.ru/course/view.php?id=1135'

downloadAndParse = (href) ->
    jar = request.jar()
    page = await request
        url: href
        jar: jar
    document = (new JSDOM(page, {url: href})).window.document
    return document

finalizeMaterialsList = (materials) ->
    materials = (m for m in materials when m)
    materials = await Promise.all(materials)
    return (m._id for m in materials)

parseLabel = (activity, order) ->
    material = new Material
        _id: activity.id,
        order: order,
        type: "label",
        text: activity.innerHTML,
        materials: []
    await material.upsert()
    return material

getPage = (href, id) ->
    document = await downloadAndParse(href)
    data = document.getElementById("content")
    if not data
        logger.error("Can't find content for page " + href)
        return undefined

    mod = data.getElementsByClassName('modified')
    for m in mod
        m.parentElement.removeChild(m)

    material = new Material
        _id: id,
        order: 0,
        type: "page",
        text: data.innerHTML,
        materials: []
    await material.upsert()
    return material

parseResource = (activity, order) ->
    icon = activity.firstChild
    material = undefined
    if activity.children.length != 2
        logger.error("Found resource with >2 children " + activity.innerHTML)
        return undefined
    a = activity.children[1]
    if icon.src.endsWith("pdf.gif")
        material = new Material
            _id: activity.id,
            order: order,
            type: "pdf",
            href: a.href
            text: a.innerHTML,
            materials: []
    else if icon.src.endsWith("image.gif")
        material = new Material
            _id: activity.id,
            order: order,
            type: "image",
            href: a.href
            text: a.innerHTML,
            materials: []
    else
        page = await getPage(a.href, activity.id + "p")
        material = new Material
            _id: activity.id,
            order: order,
            type: "pageLink",
            text: a.innerHTML,
            materials: [page._id]
    await material.upsert()
    return material

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
    if not name
        logger.error("Can't find name for problem " + href)
        return undefined

    text = "<h1>" + name.innerHTML + "</h1>"
    for tag in data
        text += "<div>" + tag.innerHTML + "</div>"

    material = new Material
        _id: "p" + id,
        order: order,
        type: "problem",
        text: text,
        materials: []
    await material.upsert()
    return material


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
    logger.info(name + ": found " + hrefs.length + " problems: " + hrefs.join(" "))

    materials = []
    for href, i in hrefs
        materials.push(getProblem(href, i))

    materials = await finalizeMaterialsList(materials)

    material = new Material
        _id: id
        order: order
        type: "contest"
        text: name
        materials: materials
    await material.upsert()
    return material


parseActivity = (activity, order) ->
    if activity.classList.contains("label")
        return parseLabel(activity, order)
    else if activity.classList.contains("resource")
        return parseResource(activity, order)
    else if activity.classList.contains("statements")
        return parseStatements(activity, order)
    return undefined

parseSection = (section, id) ->
    spacers = section.getElementsByClassName('spacer')
    for s in spacers
        s.parentElement.removeChild(s)

    activities = section.getElementsByClassName('activity')
    materials = []

    for activity, i in activities
        materials.push(parseActivity(activity, i))
    materials = await finalizeMaterialsList(materials)

    material = new Material
        _id: +id
        order: id
        type: "level"
        text: ""
        materials: materials
    await material.upsert()
    return material


export default downloadMaterials = ->
    logger.info("Start downloading materials")
    document = await downloadAndParse(url)

    materials = []

    for sectionId in [1..10]
        section = document.getElementById("section-" + sectionId)
        if not section
            continue
        materials.push(parseSection(section, sectionId))

    materials = await finalizeMaterialsList(materials)

    mainPageMaterial = new Material
        _id: "main"
        order: 0
        type: "main"
        text: ""
        materials: materials
    await mainPageMaterial.upsert()

    logger.info("Done downloading materials")
