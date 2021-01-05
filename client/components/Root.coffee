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
        <Grid fluid>
            <Row>
                {
                res = []
                a = (el) -> res.push(el)
                data = [
                    "Алгоритмы и структуры данных",
                    "Решение сложных задач",
                    "Написание надежных программ",
                    "Участие в олимпиадах",
                    "Заочные занятия для всех желающих",
                    "Для нижегородских школьников бесплатно",
                ]
                for d, index in data
                    a <Col xs={12} sm={6} md={4} lg={4} key={index}>
                        <div className={styles.item}>
                            <div className={styles.number}>
                                {index.toString(2).replace(/0/g, "○").replace(/1/g, "●")}
                            </div>
                            {d}
                        </div>
                    </Col>
                    if index % 2 == 1
                        a <Clearfix visibleSmBlock key={index + "c"}/>
                    if index % 3 == 2
                        a <Clearfix visibleMdBlock visibleLgBlock  key={index + "c2"}/>
                res}
            </Row>
        </Grid>
    </div>

export default Root = (props) ->
    <div>
        <Grid fluid>
            <PageHeader>
                <div className={styles.mainHeader}>Алгоритмическое программирование</div>
                <small>Сборы</small>
            </PageHeader>
        </Grid>
        {
        sceletonProps = {props..., location: {path: [], _id: "main"}, showNews: "hide", hideBread:true}
        `<Sceleton {...sceletonProps}><Inner match={props.match}/></Sceleton>`}
    </div>
