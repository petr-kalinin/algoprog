deepcopy = require("deepcopy")
React = require('react')
import { Link } from 'react-router-dom'
import { Nav, NavItem } from 'react-bootstrap'
import { withRouter } from 'react-router'

FontAwesome = require('react-fontawesome')

import styles from "./Tree.css"

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyResults from '../lib/withMyResults'

MAX_GLOBAL_DEPTH = 0
MAX_LOCAL_DEPTH = 0

getHref = (material) ->
    if material.type == "link"
        return material.content
    else
        return "/material/#{material._id}"

goTo = (history) ->
    (href) ->
        history.push(href)

markNeeded = (tree, id, path, globalDepth, localDepth) ->
    if tree._id == id
        tree.needed = true
        for m in tree.materials
            markNeeded(m, id, path, globalDepth + 1, 1)
    else
        tree.needed = globalDepth <= MAX_GLOBAL_DEPTH or localDepth <= MAX_LOCAL_DEPTH
        for m in tree.materials
            subNeeded = markNeeded(m, id, path, globalDepth + 1, localDepth + 1)
            tree.needed = tree.needed or subNeeded
    tree.needed = tree.needed or tree._id in path
    if tree.needed
        for m in tree.materials
            m.needed = true
    return tree.needed

colorBox = (indent, colorStyle, name) ->
    width = "15px"
    <div className={styles.colorBox + " " + colorStyle} style={{width}}>
        <div className={styles.colorBox_inner}>
            {
            if name
                <FontAwesome name={name} />
            else
                " "
            }
        </div>
    </div>

problemMark = (indent, result) ->
    if result.solved == 1
        colorBox(indent, styles.full, "check")
    else if result.ok == 1
        colorBox(indent, styles.ok, "circle")
    else if result.ignored == 1
        colorBox(indent, styles.ignored, "repeat")
    else if result.attempts > 0
        colorBox(indent, styles.wa, "times")
    else
        null

SolutionMark_ = (props) ->
    result = props.myResults?[props.myUser?._id + "::" + props.id]
    indent = props.indent
    if not result?.total?
        return null
    if result.total == 1
        return problemMark(indent, result)

    if result.solved == result.total
        colorBox(indent, styles.full, "check")
    else if result.solved > result.total / 2 # TODO
        colorBox(indent, styles.done, "check")
    else if result.solved > 0 or result.ok > 0 or result.attempts > 0
        colorBox(indent, styles.started)
    else
        null

SolutionMark = withMyResults(SolutionMark_)

recTree = (tree, id, indent) ->
    res = []
    a = (el) -> res.push(el)
    for m in tree.materials
        if m.needed and m.title
            a <NavItem key={m._id} active={m._id==id} className={(if indent>=2 then "small" else "") + " " + (if m._id!=id then styles.navitem else "") + " " + styles.levelNav} eventKey={getHref(m)} href={getHref(m)}>
                <div style={"paddingLeft": 15*indent + "px"} className={styles.levelRow}>
                    <div className={styles.levelName}>
                        {m.title}
                    </div>
                    <SolutionMark id={m._id} indent={indent}/>
                </div>
            </NavItem>
            res = res.concat(recTree(m, id, indent + 1))
    return res

Tree = (props) ->
    if not props.tree
        return null
    tree = deepcopy(props.tree)
    markNeeded(tree, props.id, (p._id for p in props.path), 0, 100)
    <div className={styles.tree}>
        <Nav bsStyle="pills" stacked onSelect={goTo(props.history)}>
            {recTree(tree, props.id, 0)}
        </Nav>
    </div>

options =
    urls: ->
        tree: "material/tree"

export default ConnectedComponent(withRouter(Tree), options)
