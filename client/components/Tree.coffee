deepcopy = require("deepcopy")
React = require('react')
tinycolor = require("tinycolor2")
import { Link } from 'react-router-dom'
import { Nav, NavItem } from 'react-bootstrap'
import { withRouter } from 'react-router'

import styles from "./Tree.css"

MAX_GLOBAL_DEPTH = 1
MAX_LOCAL_DEPTH = 1
BASE_COLOR = tinycolor({r: 100, g:100, b: 255})
ACTIVE_COLOR = "#fdf6e3"

getHref = (material) ->
    if material.type == "table"
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
            markNeeded(m, id, path, globalDepth + 1, localDepth + 1)
        if tree._id in path
            tree.needed = true
            for m in tree.materials
                m.needed = true
    return tree.needed

colorByIndent = (indent) ->
    return BASE_COLOR.clone().lighten(indent * 8).toHex()

recTree = (tree, id, indent) ->
    res = []
    a = (el) -> res.push(el)
    for m in tree.materials
        if m.needed and m.title
            if m._id == id
                color = ACTIVE_COLOR
            else
                color = colorByIndent(indent)
            a <NavItem key={m._id} active={m._id==id} className={(if indent>=2 then "small" else "") + " " + (if m._id!=id then styles.navitem else "")} eventKey={getHref(m)} href={getHref(m)}>
                <div style={"paddingLeft": 15*indent + "px"}>
                    {m.title}
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

export default withRouter(Tree)
