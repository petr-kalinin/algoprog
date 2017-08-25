deepcopy = require("deepcopy")
React = require('react')
import { Link } from 'react-router-dom'

MAX_GLOBAL_DEPTH = 1
MAX_LOCAL_DEPTH = 1

markNeeded = (tree, id, globalDepth, localDepth) ->
    if tree._id == id
        tree.needed = true
        for m in tree.materials
            markNeeded(m, id, globalDepth + 1, 1)
    else
        tree.needed = globalDepth <= MAX_GLOBAL_DEPTH or localDepth <= MAX_LOCAL_DEPTH
        needChildren = false
        for m in tree.materials
            if markNeeded(m, id, globalDepth + 1, localDepth + 1)
                needChildren = true
        if needChildren
            tree.needed = true
            for m in tree.materials
                m.needed = true
    return tree.needed

TreeRec = (props) ->
    <div>
        {props.tree.title + (if props.tree._id == props.id then "!" else "")}
        {
        res = []
        a = (el) -> res.push(el)
        for m in props.tree.materials
            if m.needed and m.title
                a <li key={m._id}><TreeRec tree={m} id={props.id}/></li>
        res && <ul>{res}</ul>
        }
    </div>

export default Tree = (props) ->
    tree = deepcopy(props.tree)
    markNeeded(tree, props.id, 0, 100)
    <TreeRec tree={tree} id={props.id}/>
