deepcopy = require("deepcopy")
React = require('react')
import { Link } from 'react-router-dom'
import { Nav, NavItem } from 'react-bootstrap'
import { withRouter } from 'react-router'

FontAwesome = require('react-fontawesome')

import styles from "./Tree.css"

import {LangRaw} from '../lang/lang'

import ConnectedComponent from '../lib/ConnectedComponent'
import withLang from '../lib/withLang'
import withMyResults from '../lib/withMyResults'
import requiredProblemsByLevel from '../lib/requiredProblemsByLevel'
import withTheme from '../lib/withTheme'

MAX_GLOBAL_DEPTH = 0
MAX_LOCAL_DEPTH = 0

getHref = (material) ->
    if material.type == "link"
        return material.content
    else
        return "/material/#{material._id}"

stripLabel = (id) ->
    idx = id.indexOf("!")
    if idx != -1
        id = id.substring(0, idx)
    return id.replace("A", "А").replace("B", "Б").replace("C", "В").replace("D", "Г")

markNeeded = (tree, id, path, globalDepth, localDepth) ->
    if tree._id == id
        tree.needed = true
        for m in tree.materials || []
            markNeeded(m, id, path, globalDepth + 1, 1)
    else
        tree.needed = globalDepth <= MAX_GLOBAL_DEPTH or localDepth <= MAX_LOCAL_DEPTH
        for m in tree.materials || []
            subNeeded = markNeeded(m, id, path, globalDepth + 1, localDepth + 1)
            tree.needed = tree.needed or subNeeded
    tree.needed = tree.needed or tree._id in path
    if tree.needed
        for m in tree.materials || []
            m.needed = true
    return tree.needed

colorBox = (indent, colorStyle, name, title) ->
    width = "15px"
    <div className={styles.colorBox + " " + colorStyle} style={{width}} title={title}>
        <div className={styles.colorBox_inner}>
            {
            if name
                <FontAwesome name={name} />
            else
                " "
            }
        </div>
    </div>

isLevelDone = (levelId, userId, results) ->
    for subLevel in ["А", "Б", "В", "Г", "A", "B", "C", "D"]
        if levelId.endsWith(subLevel)
            result = results?[userId + "::" + levelId]
            return result.solved >= requiredProblemsByLevel(levelId, result.required or 0)
    if +levelId in [1..20]
        subLevels = ["А", "Б", "В", "Г", "A", "B", "C", "D"]
        done = true
        for subLevel in subLevels
            result = results?[userId + "::" + levelId + subLevel]
            if not result
                continue
            done = done and result.solved >= requiredProblemsByLevel(levelId + subLevel, result.required or 0)
        return done
    result = results?[userId + "::" + levelId]
    return result.solved and result.solved == result.total

problemMark = (indent, result, LANG) ->
    if result.ps == 1
        colorBox(indent, styles.null, "question-circle-o", LANG("testing"))
    else if result.solved == 1
        colorBox(indent, styles.full, "check", LANG("accepted"))
    else if result.ok == 1
        colorBox(indent, styles.ok, "circle", "OK")
    else if result.ignored == 1
        colorBox(indent, styles.ignored, "repeat", LANG("ignored"))
    else if result.attempts > 0
        colorBox(indent, styles.wa, "times", LANG("partial_solution"))
    else
        colorBox(indent, styles.null)

SolutionMark = withMyResults withLang (props) ->
    LANG = (id) -> LangRaw(id, props.lang)
    id = stripLabel(props.id)
    console.log id
    result = props.myResults?[props.myUser?._id + "::" + id]
    indent = props.indent
    if not result?.total?
        return null
    if result.total == 1
        return problemMark(indent, result, LANG)

    if result.solved == result.total
        colorBox(indent, styles.full, "check", LANG("all_problems_solved"))
    else if isLevelDone(id, props.myUser?._id, props.myResults)
        colorBox(indent, styles.done, "check", LANG("laevel_done"))
    else if result.solved > 0 or result.ok > 0 or result.attempts > 0
        colorBox(indent, styles.started, undefined, LANG("level_started"))
    else
        colorBox(indent, styles.null)

recTree = (tree, id, indent, theme, prefix) ->
    res = []
    a = (el) -> res.push(el)
    for m in tree.materials || []
        if m.needed and m.title
            className = styles.levelNav
            if indent >= 2
                className += " small"
            if m._id != id
                if theme == "dark"
                    className += " " + styles.navitemDark
                else
                    className += " " + styles.navitem
            a <NavItem key={prefix + ":" + m._id} active={m._id==id} className={className} eventKey={getHref(m)} href={getHref(m)} onClick={window?.goto?(getHref(m))}>
                <div style={"paddingLeft": 15*indent + "px"} className={styles.levelRow}>
                    <div className={styles.levelName}>
                        {m.title}
                    </div>
                    <SolutionMark id={m._id} indent={indent}/>
                </div>
            </NavItem>
            res = res.concat(recTree(m, id, indent + 1, theme, prefix + ":" + m._id))
    return res

Tree = (props) ->
    if not props.tree
        return null
    tree = deepcopy(props.tree)
    markNeeded(tree, props.id, (p._id for p in props.path), 0, 100)
    <div className={styles.tree}>
        <Nav bsStyle="pills" stacked>
            {recTree(tree, props.id, 0, props.theme, "")}
        </Nav>
    </div>

options =
    urls: (props) ->
        if props.lang == "ru"
            tree: "material/tree"
        else
            tree: "material/tree!en"

export default withLang(ConnectedComponent(withTheme(withRouter(Tree)), options))
