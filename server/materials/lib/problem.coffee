import { JSDOM } from 'jsdom'

import {downloadLimited} from '../../lib/download'
import Material from "../../models/Material"

downloadAndParse = (href) ->
    page = await downloadLimited(href, {timeout: 15 * 1000})
    document = (new JSDOM(page, {url: href})).window.document
    return document

class Problem
    constructor: (@id) ->

    build: (context) ->
        href = "https://informatics.msk.ru/moodle/mod/statements/view3.php?chapterid=#{@id}"
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

        material = new Material
            _id: "p#{@id}",
            type: "problem",
            title: name,
            content: text,
            materials: []

        context.process(material)
        
        material = material.toObject()
        delete material.content
        return material

export default problem = (args...) -> new Problem(args...)