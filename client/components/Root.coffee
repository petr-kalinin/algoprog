React = require('react')

import PageHeader from 'react-bootstrap/lib/PageHeader'
import Row from 'react-bootstrap/lib/Row'
import Grid from 'react-bootstrap/lib/Grid'
import Col from 'react-bootstrap/lib/Col'
import Clearfix from 'react-bootstrap/lib/Clearfix'
import Tab from 'react-bootstrap/lib/Tab'
import Nav from 'react-bootstrap/lib/Nav'
import NavItem from 'react-bootstrap/lib/NavItem'

import { Link } from 'react-router-dom'

import Sceleton from './Sceleton'

import globalStyles from './global.css'
import Tree from './Tree'
import styles from './Root.css'

Inner = (props) ->
    <div>
    </div>

export default Root = (props) ->
    <div>
        <Grid fluid>
            <PageHeader>
                <div className={styles.mainHeader}>Школа анализа данных</div>
                <small>Нижегородский филиал</small>
            </PageHeader>
        </Grid>
        {
        sceletonProps = {props..., location: {path: [], _id: "main"}, showNews: "hide", hideBread:true}
        `<Sceleton {...sceletonProps}><Inner match={props.match}/></Sceleton>`}
    </div>
