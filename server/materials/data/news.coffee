import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("Занятий 9 марта в лицее 40 и 13 марта во ВШЭ не будет", String.raw"""
            Занятий 9 марта в лицее 40 и 13 марта во ВШЭ не будет. Занимайтесь из дома. Далее следите за объявлениями на сайте.
        """),
        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
