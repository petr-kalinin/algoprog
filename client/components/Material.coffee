React = require('react')
import { Link } from 'react-router-dom'
import { Row, Col } from 'react-bootstrap'

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
    else
        `<Problem {...props} />`

export default Material = (props) ->
    <Row>
        <Col xsHidden smHidden md={4} lg={3}>
            <Tree tree={props.tree} path={props.material.path} id={props.material._id} />
        </Col>
        <Col xs={12} sm={12} md={8} lg={6}>
            <MaterialProper material={props.material} />
        </Col>
        <Col xsHidden smHidden mdHidden lg={3}>
            <News news={props.news.materials} />
        </Col>
    </Row>
