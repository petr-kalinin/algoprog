deepcopy = require("deepcopy")
React = require('react')
import { Link } from 'react-router-dom'
import { Nav, NavItem } from 'react-bootstrap'
import { withRouter } from 'react-router'

FontAwesome = require('react-fontawesome')

import styles from "./Tree.css"

import ConnectedComponent from '../lib/ConnectedComponent'
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
    for subLevel in ["А", "Б", "В", "Г"]
        if levelId.endsWith(subLevel)
            result = results?[userId + "::" + levelId]
            return result.solved >= requiredProblemsByLevel(levelId, result.required or 0)
    if +levelId in [1..20]
        subLevels = ["А", "Б", "В", "Г"]
        done = true
        for subLevel in subLevels
            result = results?[userId + "::" + levelId + subLevel]
            if not result
                continue
            done = done and result.solved >= requiredProblemsByLevel(levelId + subLevel, result.required or 0)
        return done
    result = results?[userId + "::" + levelId]
    return result.solved and result.solved == result.total

problemMark = (indent, result) ->
    if result.ps == 1
        colorBox(indent, styles.null, "question-circle-o", "Тестируется")
    else if result.solved == 1
        colorBox(indent, styles.full, "check", "Зачтено")
    else if result.ok == 1
        colorBox(indent, styles.ok, "circle", "OK")
    else if result.ignored == 1
        colorBox(indent, styles.ignored, "repeat", "Проигнорировано")
    else if result.attempts > 0
        colorBox(indent, styles.wa, "times", "Неполное решение")
    else
        colorBox(indent, styles.null)

SolutionMark_ = (props) ->
    result = props.myResults?[props.myUser?._id + "::" + props.id]
    indent = props.indent
    if not result?.total?
        return null
    if result.total == 1
        return problemMark(indent, result)

    if result.solved == result.total
        colorBox(indent, styles.full, "check", "Решены все задачи")
    else if isLevelDone(props.id, props.myUser?._id, props.myResults)
        colorBox(indent, styles.done, "check", "Уровень пройден")
    else if result.solved > 0 or result.ok > 0 or result.attempts > 0
        colorBox(indent, styles.started, undefined, "Уровень начат")
    else
        colorBox(indent, styles.null)

SolutionMark = withMyResults(SolutionMark_)

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
    urls: ->
        tree: "material/tree"

export default ConnectedComponent(withTheme(withRouter(Tree)), options)
