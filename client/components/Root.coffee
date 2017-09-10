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

import globalStyles from './global.css'
import Tree from './Tree'
import styles from './Root.css'

export default Root = (props) ->
    <Row>
        <Col xsHidden smHidden md={4} lg={3}>
            <Tree tree={props.tree} path={[]} id="main" />
        </Col>
        <Col xs={12} sm={12} md={8} lg={9}>
            <PageHeader>
                Алгоритмические программирование<br/>
                <small>Очно-заочный курс Петра Калинина</small>
            </PageHeader>
            <Grid fluid>
                <Row>
                    {
                    res = []
                    a = (el) -> res.push(el)
                    data = [
                        "Алгоритмы и структуры данных",
                        "Написание надежных программ",
                        "Участие в олимпиадах",
                        "Заочные занятия для всех желающих",
                        "Для школьников бесплатно",
                        "Очные занятия для нижегородских школьников"
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
            <h2 className={styles.whatitis}>Что это за курс?</h2>
            <Tab.Container defaultActiveKey="school" id="info">
                <div>
                    <Nav bsStyle="pills" justified>
                        <NavItem eventKey="school" className={styles.whoami}>
                            Я школьник
                        </NavItem>
                        <NavItem eventKey="stud" className={styles.whoami}>
                            Я студент или выпускник
                        </NavItem>
                    </Nav>
                    <div className={styles.text}>
                        <Tab.Content animation>
                            <Tab.Pane eventKey="school">
                                <p>
                                    В этом курсе вы научитесь программировать, писать сложные алгоритмы и решать олимпиадные задачи. Вы
                                    подготовитесь к олимпиадам, да и задачи части C ЕГЭ вам покажутся проще. В дальнейшем
                                    полученные тут знания и умения вам помогут как в вузе, так и в любой деятельности,
                                    хоть как-то связанной с программированием.
                                </p>
                                <p>
                                    Заниматься можно как совсем начинающим, так и тем, кто уже что-то умеет.
                                    Вы можете заниматься заочно; также для нижегородцев существуют очные занятия.
                                    Занятия <Link to="/material/module-20927_9">бесплатны</Link>, хотя, если хотите,
                                    вы можете поддержать их проведение деньгами.
                                </p>
                                <p>
                                    <Link to="/material/0">Подробная информация про курс</Link><br/>
                                    <Link to="/material/module-20927_5">FAQ для школьников</Link>
                                </p>
                            </Tab.Pane>
                            <Tab.Pane eventKey="stud">
                                <p>
                                    В этом курсе вы научитесь программировать, писать сложные алгоритмы, понимать
                                    и использовать различные структуры данных. Полученные тут знания и умения помогут вам в вузе,
                                    пригодятся, если вы соберетесь работать в любой крупной IT-компании, да и вообще
                                    будут полезны в любой деятельности, хоть как-то связанной с программированием.
                                </p>
                                <p>
                                    Заниматься можно как совсем начинающим, так и тем, кто уже что-то умеет.
                                    Занятия проходят заочно. Занятия платные, информация о ценах и порядке оплаты — в FAQ курса.
                                </p>
                                <p>
                                    <Link to="/material/0">Подробная информация про курс</Link><br/>
                                    <Link to="/material/module-20927_7">FAQ для студентов и выпускников</Link>
                                </p>
                            </Tab.Pane>
                        </Tab.Content>
                    </div>
                </div>
            </Tab.Container>
        </Col>
    </Row>
