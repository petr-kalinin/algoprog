import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("Сортировка поиска ошибок", String.raw"""
            В разделе «<a href="/findMistakeList">Найди ошибку</a>» появилась возможность сортировки по статусу, чтобы вам было удобнее искать еще не решенные поиски ошибок.
            До утра 30 января раздел поиска ошибок может работать странно, с утра 30 января все должно быть нормально.
            Если обнаружите проблемы, пишите.
        """),
        newsItem("Еще два опроса", String.raw"""
            Заполните, пожалуйста, еще два опроса про алгопрог: <a href="https://docs.google.com/forms/d/e/1FAIpQLSctsMlVXG1gwRWMtPLdyKPWf3evZyZY617EL6Hijco1pGbDGQ/viewform">раз</a>, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdhHVBFN0Xs1Y3U31Z2gJWEvsUYrraGNPfueZK2LKNdq95BkA/viewform">два</a>.
        """),
        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
