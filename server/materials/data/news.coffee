import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("Очных заннятий до 10 апреля не будет. С 10 апреля планируется возобновление очных занятий.", String.raw"""
            Очных заннятий до 10 апреля не будет. Занимайтесь из дома. Если хотите, я готов организовать консультации по zoom, пишите. 
            С 10 апреля планируется возобновление очных занятий.
        """),
        
        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
