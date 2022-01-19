import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("Еще два опроса", String.raw"""
            Заполните, пожалуйста, еще два опроса про алгопрог: <a href="https://docs.google.com/forms/d/e/1FAIpQLSctsMlVXG1gwRWMtPLdyKPWf3evZyZY617EL6Hijco1pGbDGQ/viewform">раз</a>, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdhHVBFN0Xs1Y3U31Z2gJWEvsUYrraGNPfueZK2LKNdq95BkA/viewform">два</a>.
        """),
        newsItem("Занятия 19 января в лицее 40 не будет", String.raw"""
            19 января занятия в лицее 40 не будет.
        """),
        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
