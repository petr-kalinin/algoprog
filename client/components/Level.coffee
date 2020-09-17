React = require('react')
FontAwesome = require('react-fontawesome')

import { Link } from 'react-router-dom'

import {ProblemList} from './Contest'

import styles from './Level.css'

Label = (props) ->
    <div dangerouslySetInnerHTML={{__html: props.material.content}}>
    </div>

SubLevel = (props) ->
    inner = props.material.title
    if not props.noLink
        inner = <Link to="/material/#{props.material._id}">{inner}</Link>
    if props.material.sub or props.simple
        <div>{inner}</div>
    else
        <h2>{inner}</h2>

InternalLink = (props) ->
    <div>
        <Link to={props.material.content}>{props.material.title}</Link>
    </div>

MaterialLink = (props) ->
    <div className={if props.className then styles[props.className]}>
        <Link to={"/material/" + props.material._id}>{props.material.title}</Link>
    </div>

ExternalLink = (props) ->
    <div>
        <FontAwesome name={props.head}/> <a href={props.material.content}>{props.material.title}</a>
    </div>

Material = (props) ->
    switch props.material.type
        when 'label' then `<Label {...props}/>`
        when 'page' then `<MaterialLink {...props}/>`
        when 'pdf' then `<ExternalLink head="file-pdf-o" {...props}/>`
        when 'image' then `<ExternalLink head="picture-o" {...props}/>`
        when 'link' then `<ExternalLink head="external-link" {...props}/>`
        when 'contest' then `<MaterialLink {...props}/>`
        when 'level' then `<SubLevel {...props}/>`
        when 'simpleLevel' then `<SubLevel {...props}/>`
        when 'topic' then `<SubLevel {...props} noLink={true}/>`
        when 'epigraph' then `<MaterialLink {...props} className="epigraph"/>`
        when 'table' then `<InternalLink {...props}/>`
        else <div>{props.material.type}</div>

ProblemListWrapped = (props) ->
    <div className={styles.problemList}>
        {`<ProblemList {...props}/>`}
    </div>

export default Level = (props) ->
    <div>
    <h1>{props.material.title}</h1>
    {
    res = []
    problems = []
    a = (el) -> res.push(el)
    for m in props.material.materials
        if m.type == "problem"
            problems.push(m)
            continue
        if problems.length
            a <ProblemListWrapped problems={problems} key={"problems::pre-" + m._id}/>
            problems = []
        a(<div key={m._id + ":" + m.type}>
            <div className = {if props.material.type == 'topic' then styles.bigText}>
                <Material material={m} simple={props.simple}/>
            </div>
        </div>)
    if problems.length
        a <ProblemListWrapped problems={problems} key={"problems::final"}/>
    res}
    </div>
