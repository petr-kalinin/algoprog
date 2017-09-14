React = require('react')

import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'
import Grid from 'react-bootstrap/lib/Grid'
import Breadcrumb from 'react-bootstrap/lib/Breadcrumb'
import { LinkContainer } from 'react-router-bootstrap'


import { Helmet } from "react-helmet"

import Tree from './Tree'
import News from './News'

SIZES = ["xs", "sm", "md", "lg"]

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


ColWrapper = (props) ->
    subProps = {}
    for size in SIZES
        if props.size[size] == 0
            subProps[size + "Hidden"] = true
        else
            subProps[size] = props.size[size]
    `<Col {...subProps}>{props.children}</Col>`


fixSize = (prop, def) ->
    result = {def...}
    switch prop
        when "hide"
            for key, val of result
                result[key] = 0
        when "force"
            for key, val of result
                if result[key] == 0
                    result[key] = 12
    return result


getSizes = (props) ->
    treeSize = fixSize(props.showTree, {
        xs: 0
        sm: 0
        md: 4
        lg: 3
    })
    newsSize = fixSize(props.showNews, {
        xs: 0
        sm: 0
        md: 0
        lg: 3
    })
    selfSize = {}
    for size in SIZES
        selfSize[size] = 12 - treeSize[size] - newsSize[size]
        if selfSize[size] < 6
            selfSize[size] = 12

    return {treeSize, newsSize, selfSize}

export default Sceleton = (props) ->
    path = props.location.path || props.news.path
    breadPath = path.concat
        _id: props.location._id
        title: props.location.title
    {treeSize, newsSize, selfSize} = getSizes(props)
    <Grid fluid>
        <Helmet>
            {props.location?.title && <title>{props.location?.title}</title>}
        </Helmet>
        <Row>
            <ColWrapper size={treeSize}>
                <Tree tree={props.tree} path={props.location?.path || []} id={props.location?._id} />
            </ColWrapper>
            <ColWrapper size={selfSize}>
                {props.hideBread || <Bread path={breadPath} id={props.location._id} /> }
                {props.children}
            </ColWrapper>
            <ColWrapper size={newsSize}>
                <News news={props.news.materials} />
            </ColWrapper>
        </Row>
    </Grid>
