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
                    "Онлайн занятия из дома",
                    "Обучение отдаленных от столиц регионов"
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
            <p className="lead">
                В этом курсе вы научитесь программировать, писать сложные алгоритмы и решать олимпиадные задачи. В дальнейшем
                полученные тут знания и умения вам помогут как в вузе, так и в любой деятельности,
                хоть как-то связанной с программированием.
            </p>
                
        <h2 className={styles.whatitis}>Как это работает?</h2>
        {
            items = [
                {image: "about-1-levels-2.png", text: "Темы разбиты по уровням по возрастанию сложности: от основ синтаксиса до продвинутых алгоритмов. По большинству тем есть теоретические материалы (статьи, советы, видеолекции) и задачи."},
                {image: "about-2-submit.png", text: "Вы изучаете теорию и решаете задачи на языке программирования С++. Задачи отправляете на сайт, и они автоматически проверяются."},
                {image: "about-3-results.png", text: "Через минуту вы узнаете, правильное решение у вас или неправильное. Если правильное — двигаетесь дальше; если неправильное, думаете, как это исправить."},
                {image: "about-4-comments.png", text: "Все неправильные решения мы видим и можем подсказать, в чем у вас ошибка. Все правильные решения мы тоже видим и просматриваем глазами — насколько оптимально они написаны."},
                {image: "about-5-ac.png", text: "Если решение написано достаточно хорошо, мы его засчитываем. Можем еще написать небольшие комментарии по вашему коду."},
                {image: "about-6-ig.png", text: "Если решение написано не очень хорошо, мы его не засчитываем — «игнорируем». К игнорированным решениям мы пишем комментарий, и вам надо будет переделать решение."},
                {image: "about-7-best.png", text: "Когда ваше решение зачтено, вы получаете доступ к «хорошим решениям», чтобы видеть, как эту задачу решали другие ученики."},
            ]
            index = 0
            <div className="howitworks_table">
                {items.map((item) -> <div className={styles.howitworks_row + " " + if index%2==1 then styles.reverse else ""} key={item.image}>
                    {index++; null;}
                    <div className={styles.howitworks_img}>
                        <img src={item.image} width="100%" className={styles.img}/>
                    </div>
                    <div className={styles.howitworks_text}>
                        {item.text}
                    </div>
                </div>)}
            </div>
        }
    </div>

export default Root = (props) ->
    <div>
        <Grid fluid>
            <PageHeader>
                <div className={styles.mainHeader}>Учебный Центр M&C. Дистанционное обучение.</div>
            </PageHeader>
        </Grid>
        {
        sceletonProps = {props..., location: {path: [], _id: "main"}, showNews: "hide", hideBread:true}
        `<Sceleton {...sceletonProps}><Inner match={props.match}/></Sceleton>`}
    </div>
