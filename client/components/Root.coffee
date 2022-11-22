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

import withLang from '../lib/withLang'

import Sceleton from './Sceleton'

import globalStyles from './global.css'
import Tree from './Tree'
import styles from './Root.css'

InnerRu = (props) ->
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
                {image: "about-1-levels.png", text: "Темы разбиты по уровням по возрастанию сложности: от основ синтаксиса до продвинутых алгоритмов. По большинству тем есть теоретические материалы (статьи, советы, видеолекции) и задачи."},
                {image: "about-2-submit.png", text: "Вы изучаете теорию и решаете задачи на языке программирования С++. Задачи отправляете на сайт, и они автоматически проверяются."},
                {image: "about-3-results.png", text: "Через минуту вы узнаете, правильное решение у вас или неправильное. Если правильное — двигаетесь дальше; если неправильное, думаете, как это исправить."},
                {image: "about-4-comments.png", text: "Все неправильные решения мы видим и можем подсказать, в чем у вас ошибка. Все правильные решения мы тоже видим и просматриваем глазами — насколько оптимально они написаны."},
                {image: "about-5-ac.png", text: "Если решение написано достаточно хорошо, мы его засчитываем. Можем еще написать небольшие комментарии по вашему коду."},
                {image: "about-6-ig.png", text: "Если решение написано не очень хорошо, мы его не засчитываем — «игнорируем». К игнорированным решениям мы пишем комментарий, и вам надо будет переделать решение."},
                {image: "about-7-best.png", text: "Когда ваше решение зачтено, вы можете посмотреть «хорошие решения», чтобы видеть, как эту задачу решали другие ученики. Также вы получаете доступ к разделу «поиск ошибок», где вы можете искать ошибки в решениях других учеников по этой задаче."},
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

InnerEn = (props) ->
    <div>
        <Grid fluid>
            <Row>
                {
                res = []
                a = (el) -> res.push(el)
                data = [
                    "Algorithms and data structures",
                    "From basic coding to really advanced topics"
                    "Solve complex problems",
                    "Thouroughly test code",
                    "Participate in programming contests",
                    "Prepare for coding interview",
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
        <h2 className={styles.whatitis}>What is it?</h2>
        <div className={styles.text}>
            <p className="lead">
                In this course you will learn how to code, write complex algorithms, understand
                and use advanced data structures. The knowledge and skills gained here 
                will help you at the university, will be required if you are going to work 
                in any large IT company, and  even outside of IT companies they will be useful in any activity at least in some way related to programming.
            </p>
            <p className="lead">
                Both complete beginners and people who have programming experience can study in the course.
                The course is completely online. 
            </p>
            <p className="lead">
                <Link to="/material/about">Detailed information about the couse</Link>{" | "}
                <Link to="/material/about.4!en">FAQ</Link>
            </p>
        </div>
        <h2 className={styles.whatitis}>How does the couse work?</h2>
        {
            items = [
                {image: "about-1-levels-en.png", text: "The topics are divided into levels by increasing complexity: from the basics of syntax to advanced algorithms. There are theoretical materials (articles, tips, video lectures) and practice problems on most topics."},
                {image: "about-2-submit-en.png", text: "You study theory and solve problems in your favorite programming language. You send solutions to the site, and they are automatically checked."},
                {image: "about-3-results-en.png", text: "In a minute you will know whether your solution is correct. If it's right, you move on; if it's wrong, you think how to fix it."},
                {image: "about-4-comments-en.png", text: "I see all the wrong solutions and can tell you what your mistake is. I also see all the correct solutions and check them manually — how optimally they are written."},
                {image: "about-5-ac-en.png", text: "If the solution is written well enough, I accept it. I can also write small comments on your code."},
                {image: "about-6-ig-en.png", text: "If the solution is not written very well, I do not accept  it — I 'ignore' it. In this case I always write a comment, and you will need to redo the solution."},
                {image: "about-7-best-en.png", text: "When your solution is accepted, you can look at 'good solutions' to see how other students solved this problem. You also get access to 'find mistake' section where you can try to find mistakes in solutions by other students."},
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
        <h2 className={styles.whatitis}>How to enroll to the course?</h2>
        <p className="lead"><Link to="/register">Sign up</Link> on this site and write me (my contacts are in <Link to="/material/about">About course</Link> page).</p>
    </div>

RootRu = (props) ->
    <div>
        <Grid fluid>
            <PageHeader>
                <div className={styles.mainHeader}>Учебный Центр M&C. Дистанционное обучение.</div>
            </PageHeader>
        </Grid>
        {
        sceletonProps = {props..., location: {path: [], _id: "main"}, showNews: "hide", hideBread:true}
        `<Sceleton {...sceletonProps}><InnerRu match={props.match}/></Sceleton>`}
    </div>

RootEn = (props) ->
    <div>
        <Grid fluid>
            <PageHeader>
                <div className={styles.mainHeader}>Algorithmic programming</div>
                <small>Online course by Petr Kalinin</small>
            </PageHeader>
        </Grid>
        {
        sceletonProps = {props..., location: {path: [], _id: "main"}, showNews: "hide", hideBread:true}
        `<Sceleton {...sceletonProps}><InnerEn match={props.match}/></Sceleton>`}
    </div>

Root = (props) ->
    if props.lang == "ru"
        <RootRu {props...}/>
    else if props.lang == "en"
        <RootEn {props...}/>
    else
        throw "Unknown lang"

export default withLang(Root)