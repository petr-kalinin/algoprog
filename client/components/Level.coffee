React = require('react')
import { Link } from 'react-router-dom'

Label = (props) ->
    <div dangerouslySetInnerHTML={{__html: props.material.text}}>
    </div>

PageLink = (props) ->
    <div>
        <Link to={"/material/" + props.material.materials[0]}>{props.material.text}</Link>
    </div>

LinkMaterial = (props) ->
    <div>
        {props.head}: <a href={props.material.href}>{props.material.text}</a>
    </div>

Problems = (props) ->
    <div>
        <Link to={"/problems/" + props.material._id}>{props.material.text}</Link>
    </div>

Material = (props) ->
    switch props.material.type
        when 'label' then `<Label {...props}/>`
        when 'pageLink' then `<PageLink {...props}/>`
        when 'pdf' then `<LinkMaterial head="pdf" {...props}/>`
        when 'image' then `<LinkMaterial head="image" {...props}/>`
        when 'problems' then `<Problems {...props}/>`
        else <div>{props.material.type}</div>

export default Level = (props) ->
    <div>
    {
    res = []
    a = (el) -> res.push(el)
    for m in props.level.materials
        a <Material material={m} key={m._id}/>
    res}
    </div>
