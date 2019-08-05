import { JSDOM } from 'jsdom'

import Material from "../models/Material"
import {downloadLimited} from '../lib/download'

import logger from '../log'
import awaitAll from '../../client/lib/awaitAll'

import {REGION_CONTESTS, ROI_CONTESTS} from './downloadContests'

url = 'https://informatics.msk.ru/course/view.php?id=1135'

clone = (material) ->
    JSON.parse(JSON.stringify(material))

downloadAndParse = (href) ->
    page = await downloadLimited(href, {timeout: 15 * 1000})
    document = (new JSDOM(page, {url: href})).window.document
    return document

finalizeMaterialsList = (materials) ->
    materials = (m for m in materials when m)
    materials = await awaitAll(materials)
    materials = (m for m in materials when m)
    return materials

getIndent = (activity) ->
    indent = 0
    while true
        spacers = activity.getElementsByClassName('spacer')
        if spacers.length == 0
            break
        spacers[0].parentElement.removeChild(spacers[0])
    if indent > 0
        indent -= 20
    return indent

getPageContent = (href) ->
    document = await downloadAndParse(href)
    data = document.getElementById("content")
    if not data
        throw Error("Can't find content for page " + href)

    while true
        mod = data.getElementsByClassName('modified')
        if mod.length == 0
            break
        mod[0].parentElement.removeChild(mod[0])

    return data

getProblemsHrefsFromStatements = (href) ->
    document = await downloadAndParse(href)
    toc = document.getElementsByClassName("statements_toc_alpha")
    if toc.length > 1
        throw Error("Found several tocs in statements " + href)
    toc = toc[0]

    hrefs = []
    tags = toc.getElementsByTagName("a")
    for tag in tags
        if tag.href.startsWith("https://informatics.msk.ru/mod/statements/view3.php")
            hrefs.push(tag.href)
        else
            throw Error("Strange link in statements toc: " + tag.href + " " + href)

    allATags = document.getElementsByTagName("a")
    firstProblemHref = undefined
    s = ""
    for tag in allATags 
        s += tag.title + "\n"
        if tag.title == "Print This Problem"
            firstProblemHref = tag.href.replace("print3", "view3")

    if not firstProblemHref
        throw Error("Can not detect first problem href at #{href} (#{s})")

    hrefs.splice(0, 0, firstProblemHref)

    return hrefs

getLevelHeader = (material, header, nameRegex) ->
    if material.type != "label"
        return undefined

    if not nameRegex
        nameRegex = '(Уровень\\s+(.*))'

    re = new RegExp '\\s*<' + header + '>' + nameRegex + '</' + header + '>'
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

getTopic = (material) ->
    getLevelHeader(material, 'h4', '(.*)')

parseProblem = (id, href, order) ->
    document = await downloadAndParse(href)
    submit = document.getElementById('submit')
    if submit
        submit.parentElement.removeChild(submit)

    data = document.getElementsByClassName("problem-statement")
    if not data or data.length == 0
        logger.warn("Can't find statement for problem " + href)
        data = []

    name = document.getElementsByTagName("title")[0] || ""
    name = name.innerHTML

    re = new RegExp '^.*?\\((.*)\\)$'
    res = re.exec name
    name = res[1]
    if not name
        logger.warn Error("Can't find name for problem " + href)
        name = "???"

    text = "<h1>" + name + "</h1>"
    for tag in data
        need = true
        pred = tag.parentElement
        while pred
            if pred.classList.contains("problem-statement")
                need = false
                break
            pred = pred.parentElement
        if need
            text += "<div>" + tag.innerHTML + "</div>"

    return new Material
        _id: "p" + id,
        order: order,
        type: "problem",
        title: name,
        content: text,
        materials: []


class MaterialsDownloader
    constructor: ->
        @materials = {}
        @news = []
        @urlToMaterial = {}

    getUrlKey: (url) ->
        res = /mod\/resource\/view\.php\?id=(\d+)/.exec(url)
        add = "in"
        if not res
            res = /mod\/statements\/view3\.php\?id=\d+\&chapterid=(\d+)/.exec(url)
            add = "inp"
        if not res
            return null
        result = add + res[1]
        return result

    addMaterial: (material) ->
        @materials[material._id] = material

    addNews: (header, element) ->
        @news.push
            header: header
            type: "news"
            content: element.innerHTML

    makePageMaterial: (href, id, order, type, indent, title, path) ->
        data = await getPageContent(href)  # noawait
        id_el = data.getElementsByClassName('algoprog-id')
        if id_el.length
            id_el = id_el[0]
            id = id_el.name
            id_el.parentElement.removeChild(id_el)

        return new Material
            _id: id,
            order: order,
            type: type
            indent: indent
            content: data.innerHTML
            title: title,
            path: path
            materials: []

    parseLink: (a, id, order, keepResourcesInTree, indent, icon, type, path) ->
        material = undefined
        if icon?.src?.endsWith("pdf.gif")
            material = new Material
                _id: id,
                order: order,
                type: "pdf",
                indent: indent
                content: a.href
                title: a.innerHTML,
                path: path
                materials: []
        else if icon?.src?.endsWith("image.gif")
            material = new Material
                _id: id,
                order: order,
                type: "image",
                indent: indent
                content: a.href
                title: a.innerHTML,
                path: path
                materials: []
        else if icon?.src?.endsWith("web.gif")
            material = new Material
                _id: id,
                order: order,
                type: "link",
                indent: indent
                content: a.href
                title: a.innerHTML,
                path: path
                materials: []
        else
            material = await @makePageMaterial(a.href, id, order, type || "page", indent, a.textContent, path)
        @addMaterial(material)
        tree = null
        if keepResourcesInTree and material.type == "page"
            tree = clone(material)
            delete tree.content
        if material.type == "page"
            @urlToMaterial[@getUrlKey(a.href)] = material._id
        return
            material: material
            tree: tree

    makeLabelMaterial: (id, order, indent, content) ->
        material = new Material
            _id: id,
            order: order
            indent: indent
            type: "label",
            title: "",
            content: content,
            materials: []
        @addMaterial(material)
        return
            material: material
            tree: null

    makeSpecialPage: (id, order, indent, element, keepResourcesInTree) ->
        a = element.getElementsByTagName("a")
        if a.length != 1
            throw Error("Found resource with != 1 children " + element.innerHTML)
        type = "page"
        if element.classList?.contains("algoprog-epigraph")
            type = "epigraph"
        return @parseLink(a[0], id, order, keepResourcesInTree, indent, {src: ""}, type)

    parseLabel: (activity, order, keepResourcesInTree) ->
        indent = getIndent(activity)
        materials = []
        currentText = ""
        id = 0
        for child in activity.childNodes
            if child.classList?.contains("algoprog-page") or child.classList?.contains("algoprog-epigraph")
                if currentText
                    materials.push(await @makeLabelMaterial(activity.id + "_" + id, order + id, indent, currentText))
                    currentText = ""
                    id++
                materials.push(await @makeSpecialPage(activity.id + "_" + id, order + id, indent, child, keepResourcesInTree))
                id++
            else if child.nodeType != 8  # Node.COMMENT_NODE
                currentText += child.outerHTML || child.nodeValue
        if currentText
            materials.push(await @makeLabelMaterial(activity.id + "_" + id, order + id, indent, currentText))
        return materials

    parseResource: (activity, order, keepResourcesInTree) ->
        indent = getIndent(activity)
        icon = activity.firstChild
        if activity.children.length != 2
            throw Error("Found resource with >2 children " + activity.innerHTML)
        a = activity.children[1]
        return @parseLink(a, activity.id, order, keepResourcesInTree, indent, icon)

    getProblem: (href, order) ->
        re = new RegExp '.*view3.php\\?id=\\d+&chapterid=(\\d+)'
        res = re.exec href
        id = res[1]

        oldMaterial = await Material.findById("p#{id}")
        if oldMaterial?.force
            logger.info("Will not overwrite a forced material #{id}")
            material = oldMaterial
        else
            material = await parseProblem(id, href, order)
                
        @addMaterial(material)
        @urlToMaterial[@getUrlKey(href)] = material._id
        tree = clone(material)
        delete tree.content
        return
            material: material
            tree: tree

    parseContest: (href, id, name, order, indent) ->
        hrefs = await getProblemsHrefsFromStatements(href)

        materials = []
        for href, i in hrefs
            materials.push(@getProblem(href, i))

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
        @addMaterial(material)

        tree = clone(material)
        delete tree.indent
        tree.materials = trees
        return
            material: material
            tree: tree

    parseStatements: (activity, order) ->
        indent = getIndent(activity)
        if activity.children.length != 2
            throw Error("Found resource with >2 children " + activity.innerHTML)
        a = activity.children[1]

        re = new RegExp 'view.php\\?id=(\\d+)'
        res = re.exec a.href
        id = res[1]

        return @parseContest(a.href, id, a.innerHTML, order, indent)

    parseActivity: (activity, order, keepResourcesInTree) ->
        if activity.classList.contains("label")
            return @parseLabel(activity, order, keepResourcesInTree)
        else if activity.classList.contains("resource")
            return @parseResource(activity, order, keepResourcesInTree)
        else if activity.classList.contains("statements")
            return @parseStatements(activity, order)
        return undefined

    splitLevel: (materials) ->
        levels = []
        trees = []
        currentLevel = undefined
        currentTree = undefined
        order = 0
        pendingMaterials = []
        title = ''
        currentTopics = []
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
                    levels = levels.concat currentTopics
                    trees.push currentTree
                currentLevel = new Material
                    _id: sublevel._id
                    order: order
                    type: "level"
                    title: sublevel.name
                    materials: (m.material for m in pendingMaterials)
                currentTree = clone(currentLevel)
                currentTree.materials = (m.tree for m in pendingMaterials when m.tree)
                order += 1
                pendingMaterials = []
                currentTopics = []
            topic = getTopic(m.material)
            if topic
                label = @makeLabelMaterial(m.material._id + "t", m.material.order, 20, topic.name)
                currentTopics.push label.material
            if not currentLevel
                pendingMaterials.push clone(m)
            else
                currentLevel.materials.push clone(m.material)
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

    parseNews: (element) ->
        header = element.getElementsByClassName('algoprog-header')
        if header.length != 1
            throw Error("Missing or several headers for news " + element.innerHTML)
        headerText = header[0].innerHTML
        header[0].parentElement.removeChild(header[0])
        @addNews(headerText, element)

    parseSection: (section, id) ->
        while true
            h = section.getElementsByClassName('algoprog-hidden')
            if h.length == 0
                break
            h[0].parentElement.removeChild(h[0])

        while true
            news = section.getElementsByClassName('algoprog-news')
            if news.length == 0
                break
            @parseNews(news[0])
            news[0].parentElement.removeChild(news[0])

        activities = section.getElementsByClassName('activity')
        materials = []

        for activity, i in activities
            parsed = @parseActivity(activity, i, id==0)
            materials.push(parsed)
        materials = await finalizeMaterialsList(materials)
        materials = [].concat.apply([], materials);  # flatten

        split = @splitLevel(materials)
        materials = split.levels
        title = split.title
        trees = split.trees
        pendingMaterials = split.pendingMaterials

        if id == 0
            title = "О курсе"

        for m in materials
            for mm in m.materials
                if mm.type == "page"
                    mm.content = ""
            @addMaterial(m)

        material = new Material
            _id: id
            order: id
            type: "level"
            indent: 0
            title: title
            content: ""
        material.materials = (m.material for m in pendingMaterials when m.material)
        material.materials = material.materials.concat({_id: m._id, title: m.title, type: m.type, content: m.content, indent: m.indent} for m in materials)
        @addMaterial(material)

        tree = clone(material)
        delete tree.indent
        tree.materials = (m.tree for m in pendingMaterials when m.tree).concat(trees)
        return
            material: material
            tree: tree

    makeRegContestMaterial: (contest, name, order) ->
        href =  "https://informatics.msk.ru/mod/statements/view.php?id=#{contest}"
        @parseContest(href, contest, name, order, 0)

    makeRegYearMaterial: (prefix, year, contests) ->
        materials = []
        for contest, i in contests
            if contests.length > 1
                name = "#{year}, #{i+1} тур"
            else
                name = "#{year}"
            parsed = @makeRegContestMaterial(contest, name, i)
            materials.push(parsed)
        materials = await finalizeMaterialsList(materials)
        title = year

        material = new Material
            _id: "#{prefix}#{year}"
            order: year
            type: "level"
            indent: 0
            title: title
            content: ""
            materials: [(await @makeLabelMaterial("#{prefix}#{year}head", 0, 0, "<h2>#{title}</h2>")).material]
        for m in materials
            mm = clone(m.material)
            delete mm.materials
            material.materials.push(mm)
        @addMaterial(material)

        tree = clone(material)
        delete tree.indent
        tree.materials = (m.tree for m in materials)
        return
            material: material
            tree: tree

    makeRegMaterial: (prefix, all_contests, title, order) ->
        materials = []
        for year, contests of all_contests
            parsed = @makeRegYearMaterial(prefix, year, contests)
            materials.push(parsed)
        materials = await finalizeMaterialsList(materials)

        material = new Material
            _id: prefix
            order: order
            type: "level"
            indent: 0
            title: title
            content: ""
            materials: [(await @makeLabelMaterial("#{prefix}head", 0, 0, "<h2>#{title}</h2>")).material]
        for m in materials
            mm = clone(m.material)
            delete mm.materials
            material.materials.push(mm)
        @addMaterial(material)

        tree = clone(material)
        delete tree.indent
        tree.materials = (m.tree for m in materials)
        console.log "Returning reg material ", material
        return
            material: material
            tree: tree

    fillPaths: (material, path) ->
        material.path = path
        path = path.concat
            _id: material._id
            title: material.title
        if not material.materials
            throw Error("Have no submaterials #{material}")
        for m in material.materials
            @fillPaths(@materials[m._id], path)

    save: ->
        promises = []
        for id, material of @materials
            promises.push(material.upsert())
        await awaitAll(promises)

    saveNews: ->
        material = new Material
            _id: "news",
            materials: @news
            path: [{_id: "main", title: "/"}]

        await material.upsert()

    createTableMaterials: ->
        getTableTitle = (table) ->
            if table == "reg"
                return "Сводная таблица по региональным олимпиадам"
            else if table == "roi"
                return "Сводная таблица по всероссийским олимпиадам"
            else if table == "main"
                return "Сводная таблица по всем уровням"
            else if table == "byWeek"
                return "Сводная таблица по неделям"
            tables = table.split(",")
            if tables.length == 1
                return "Сводная таблица по уровню " + table
            else
                return "Сводная таблица по уровням " + tables.join(", ")

        getTreeTitle = (table) ->
            if table == "reg"
                return "Региональные олимпиады"
            else if table == "reg"
                return "Всероссийские олимпиады"
            else if table == "main"
                return "Все уровни"
            else if table == "byWeek"
                return "По неделям"
            tables = table.split(",")
            if tables.length == 1
                return "Уровень " + table
            else
                return "Уровни " + tables.join(", ")

        getTableLink = (group, table) ->
            if table == "byWeek"
                return "/solvedByWeek/#{group}"
            return "/table/#{group}/#{table}"

        groups =
            lic40: "Лицей 40",
            zaoch: "Нижегородские школьники",
            notnnov: "Остальные школьники"
            stud: "Студенты и старше"
        tables = ["1А,1Б", "1В,1Г", "2", "3", "4", "5", "6", "7", "8", "9", "main", "reg", "roi", "byWeek"]
        materials = []
        trees = []
        globalHeaderMaterial = new Material
            _id: "table:header"
            type: "label",
            content: "<h1>Сводные таблицы</h1>"
        @addMaterial(globalHeaderMaterial)
        materials.push(globalHeaderMaterial)
        for group, groupName of groups
            thisMaterials = []
            thisTrees = []
            headerMaterial = new Material
                _id: "table:#{group}:header"
                type: "label",
                content: "<h1>#{groupName}: сводные таблицы</h1>"
            @addMaterial(headerMaterial)
            thisMaterials.push(headerMaterial)

            for table in tables
                subMaterial = new Material
                    _id: "table:" + group + ":" + table
                    type: "table",
                    title: getTableTitle(table)
                    content: getTableLink(group, table)
                @addMaterial(subMaterial)
                thisMaterials.push(subMaterial)

                subTree = clone(subMaterial)
                subTree.title = getTreeTitle(table)
                subTree.type = "link"
                thisTrees.push(subTree)

            material = new Material
                _id: "tables:#{group}"
                type: "level"
                title: groupName
                materials: thisMaterials
            @addMaterial(material)
            materials.push(material)

            tree = clone(material)
            tree.materials = thisTrees
            trees.push(tree)

        material = new Material
            _id: "tables"
            type: "level"
            title: "Сводные таблицы"
            materials: ({_id: m._id, title: m.title, type: m.type, content: m.content} for m in materials)
        @addMaterial(material)

        tree = clone(material)
        tree.materials = trees

        return
            material: material
            tree: tree

    createNewsTree: ->
        return
            _id: "news",
            type: "link"
            content: "/news"
            title: "Новости"
            materials: []

    correctInternalLinksInMaterial: (material) ->
        if not (material.type in ["page", "label", "epigraph", "problem", "news"])
            return
        document = (new JSDOM(material.content, {url: "https://informatics.msk.ru"})).window.document
        links = document.getElementsByTagName("a")
        subpath = [{_id: "main", title: "/"}]
        if material.path and material._id
            subpath = [material.path..., {_id: material._id, title: material.title}]
        else if material._id
            subpath = [subpath..., {_id: material._id, title: material.title}]
        subpath = (p for p in subpath when p.title)
        for a in links
            href = a.href
            key = @getUrlKey(href)
            match = href.match(/^https?:\/\/algoprog.ru(.*)$/)
            if match
              newhref = match[1]
            else
              if not key
                 continue
              if not (key of @urlToMaterial)
                  await @parseLink(a, key, 0, false, 0, undefined, undefined, subpath)
              if not (key of @urlToMaterial)
                  throw Error("Found internal link without a material: #{href}")
                  continue
              newhref = "/material/#{@urlToMaterial[key]}"
            a.href = newhref
            a.setAttribute("onclick", "window.goto('#{newhref}')();return false;")
        body = document.getElementsByTagName("body")[0]
        material.content = body.innerHTML
        
    correctInternalLinks: ->
        promises = []
        for id, material of @materials
            promises.push(@correctInternalLinksInMaterial(material))
            for m in material.materials
                promises.push(@correctInternalLinksInMaterial(m))
        for n in @news
            promises.push(@correctInternalLinksInMaterial(n))
        await awaitAll(promises)

    run: ->
        document = await downloadAndParse(url)

        materials = []

        for sectionId in [0..10]
            section = document.getElementById("section-" + sectionId)
            if not section
                continue
            materials.push(@parseSection(section, sectionId))

        #    makeRegMaterial: (prefix, all_contests, title, order) ->
        materials.push(@makeRegMaterial("reg", REGION_CONTESTS, "Региональные олимпиады", 100))
        materials.push(@makeRegMaterial("roi", ROI_CONTESTS, "Всероссийские олимпиады", 200))

        materials.push(@createTableMaterials())

        materials = await finalizeMaterialsList(materials)

        mainPageMaterial = new Material
            _id: "main"
            order: 0
            type: "main"
            title: "/"
            materials: (m.material for m in materials)
        @addMaterial(mainPageMaterial)

        @fillPaths(mainPageMaterial, [])
        await @correctInternalLinks()
        @save()

        trees = (m.tree for m in materials)
        trees.splice(1, 0, @createNewsTree())
        
        treeMaterial = new Material
            _id: "tree",
            materials: trees
        await treeMaterial.upsert()

        @saveNews()


export default downloadMaterials = ->
    logger.info("Start downloading materials")
    await (new MaterialsDownloader().run())
    logger.info("Done downloading materials")
