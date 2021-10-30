import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("Районная олимпиада", String.raw"""
            Районная олимпиада в Нижегородской области в этом году будет, предварительно, 16 декабря. На сайт добавлена <a href="/material/raion_olympiad">подробная информация</a>, также в <a href="/raion_archive.pdf">архив районных олимпиад</a> добавлены задачи прошлого года</a>.
        """),
        newsItem("Отмена занятий до 7 ноября включительно", String.raw"""
            Очных занятий 27 октября и 3 ноября в лицее 40; а также 31 октября и 7 ноября в ВШЭ не будет. Занимайтесь из дома.
        """),
        newsItem("Командная олимпиада", String.raw"""
            Добавлена информация <a href="/material/koshp">про командную олимпиаду</a>
        """),
        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
