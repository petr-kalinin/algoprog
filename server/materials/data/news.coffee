import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("С 10 апреля возобновляются очные занятия", String.raw"""
            С 10 апреля возобновляются очные занятия — как во ВШЭ, так и в лицее 40, по обычному расписанию.
        """),

        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
