React = require('react')
import { Link } from 'react-router-dom'
import { Row, Col, Breadcrumb } from 'react-bootstrap'
import { LinkContainer } from 'react-router-bootstrap'

import Problem from './Problem'
import Level from './Level'
import Contest from './Contest'
import Tree from './Tree'
import News from './News'

Page = (props) ->
    <div dangerouslySetInnerHTML={{__html: props.material.content}}>
    </div>

MaterialProper = (props) ->
    if props.material.type == 'page'
        `<Page {...props} />`
    else if props.material.type == 'level'
        `<Level {...props} />`
    else if props.material.type == 'contest'
        `<Contest {...props} />`
    else if props.material.type == 'epigraph'
        `<Page {...props} />`
    else if props.material.type == 'problem'
        `<Problem {...props} />`
    else
        <div>Unknown material type</div>

Bread = (props) ->
    <Breadcrumb>
        {
        props.path.map((p) ->
            href = if p._id != "main" then "/material/" + p._id else "/"
            <LinkContainer to={href} key={p._id} isActive={() -> false}>
                 <Breadcrumb.Item active={p._id==props.id}>
                    {p.title}
                </Breadcrumb.Item>
            </LinkContainer>
        )
        }
    </Breadcrumb>

export default Material = (props) ->
    breadPath = props.material.path.concat
        _id: props.material._id
        title: props.material.title
    <div>
        <Bread path={breadPath} id={props.material._id} />
        <MaterialProper material={props.material} />
    </div>
