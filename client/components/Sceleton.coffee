React = require('react')

import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'
import Grid from 'react-bootstrap/lib/Grid'
import Breadcrumb from 'react-bootstrap/lib/Breadcrumb'
import { LinkContainer } from 'react-router-bootstrap'


import { Helmet } from "react-helmet"

import Tree from './Tree'
import News from './News'

Bread = (props) ->
    <Breadcrumb>
        {
        props.path.map((p) ->
            href = if p._id != "main" then "/material/" + p._id else "/"
            title = if p._id != "main" then p.title else "/"
            <LinkContainer to={href} key={p._id} isActive={() -> false}>
                 <Breadcrumb.Item active={p._id==props.id}>
                    {title}
                </Breadcrumb.Item>
            </LinkContainer>
        )
        }
    </Breadcrumb>


export default Sceleton = (props) ->
    breadPath = props.location.path.concat
        _id: props.location._id
        title: props.location.title
    <Grid fluid>
        <Helmet>
            {props.location?.title && <title>{props.location?.title}</title>}
        </Helmet>
        <Row>
            <Col xsHidden smHidden md={4} lg={3}>
                <Tree tree={props.tree} path={props.location?.path} id={props.location?._id} />
            </Col>
            <Col xs={12} sm={12} md={8} lg={6 + if props.hideNews then 3 else 0}>
                {props.hideBread || <Bread path={breadPath} id={props.location._id} /> }
                {props.children}
            </Col>
            {props.hideNews || <Col xsHidden smHidden mdHidden lg={3}>
                <News news={props.news.materials} />
            </Col>}
        </Row>
    </Grid>
