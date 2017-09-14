React = require('react')

import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'
import Grid from 'react-bootstrap/lib/Grid'

import { Helmet } from "react-helmet"

import Tree from './Tree'
import News from './News'

export default Sceleton = (props) ->
    <Grid fluid>
        <Helmet>
            {props.location?.title && <title>{props.location?.title}</title>}
        </Helmet>
        <Row>
            <Col xsHidden smHidden md={4} lg={3}>
                <Tree tree={props.tree} path={props.location?.path} id={props.location?._id} />
            </Col>
            <Col xs={12} sm={12} md={8} lg={6}>
                {props.children}
            </Col>
            <Col xsHidden smHidden mdHidden lg={3}>
                <News news={props.news.materials} />
            </Col>
        </Row>
    </Grid>
