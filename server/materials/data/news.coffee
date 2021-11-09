import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("14 ноября занятие во ВШЭ пройдет с 11.00 до 14.00", String.raw"""
            14 ноября занятие во ВШЭ пройдет с 11.00 до 14.00.
        """),
        newsItem("Районная олимпиада", String.raw"""
            Районная олимпиада в Нижегородской области в этом году будет, предварительно, 16 декабря. На сайт добавлена <a href="/material/raion_olympiad">подробная информация</a>, также в <a href="/raion_archive.pdf">архив районных олимпиад</a> добавлены задачи прошлого года</a>.
        """),
        newsItem("Командная олимпиада", String.raw"""
            Добавлена информация <a href="/material/koshp">про командную олимпиаду</a>
        """),
        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
