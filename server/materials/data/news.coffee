import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("Занятия в лицее 40", String.raw"""
            Первое занятие в лицее 40 в этом учебном году будет 8 сентября <b>в 15:00</b>. На него можно приходить только тем лицеистам, 
            кто ходил на очные занятия раньше, или у кого уровень минимум 2.<br/>
            Первое занятие для новичков будет 15 сентября <b>в 15:00</b>.
        """),
        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
