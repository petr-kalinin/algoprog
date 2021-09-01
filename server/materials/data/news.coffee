import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("Недоступность алгопрога 4 сентября", String.raw"""
            В субботу 4 сентября днем на алгопроге планируются технические работы, сервер будет недоступен.
            Ориентировочное время —  с 14.00 до 17.00, возможно продление работ в случае возникновения технических проблем.
        """),
        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
