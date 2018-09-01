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
import ConnectedComponent from '../lib/ConnectedComponent'
import Material from '../components/Material'

import globalStyles from './global.css'
import Tree from './Tree'
import styles from './Root.css'

Root = (props) ->
    <div>
        <Grid fluid>
            <PageHeader>
                <div className={styles.mainHeader}>Алгоритмы и структуры данных</div>
                <small>Школа анализа данных, Нижегородский филиал</small>
            </PageHeader>
        </Grid>
        {
        sceletonProps = {props..., location: {path: [], _id: "main"}, showNews: "hide", hideBread:true}
        `<Sceleton {...sceletonProps}><Material material={props.data}/></Sceleton>`}
    </div>

options =
    urls: (props) ->
        data: "material/main"

export default ConnectedComponent(Root, options)