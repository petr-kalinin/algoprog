import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("Переход на новый год и деактивация аккаунтов", String.raw"""
            В связи с началом нового учебного года я деактивировал все аккаунты. Если вы планируете продолжать заниматься, напишите мне, я активирую аккаунт обратно; школьники также напишите, в каком классе и какой школы вы будете учиться в следующем учебном году.
        """),
        newsItem("Летние алгопрог-сборы, окончательная информация", String.raw"""
            <p>Летние алгопрог-сборы пройдут с 24 по 30 июля. <a href="https://docs.google.com/forms/d/e/1FAIpQLSdTnHE1ty_YPDY-hfLcjRD6-lojRVUC0VpyPUEgZaVNWJnynQ/viewform">Подробная информация и анкета для заявок</a>.</p>
        """),
        newsItem("Летния стажировка на алгопроге", String.raw"""
            В этом году, как и в прошлые годы, летом будет проходить <a href="/material/internship">стажировка на алгопроге</a>. Кто хочет участвовать — пишите.
        """),
        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
