import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("Окончание очных занятий в этом году", String.raw"""
            Последние очные занятия в этом учебном году состоятся 25 мая в лицее 40 и 29 мая во ВШЭ. Летом очных занятий не будет. 
            В следующем учебном году занятия начнутся ориентировочно в середине сентября, следите за объявлениями на сайте.
        """),


        newsItem("28 мая пройдет XVIII олимпиада им В. Д. Лелюха", String.raw"""
            28 мая 2022 года состоится XVIII Нижегородская городская олимпиада школьников по информатике им. В.Д. Лелюха. <a href="/material/nnoi_about">Подробнее</a>
        """),
        newsItem("ЛКШ и летние школы в целом", String.raw"""
            Добавлена информация про <a href="/material/sis">Летнюю компьютерную школу</a>, а также <a href="/material/summerSchools">про летние школы в целом</a>.
        """),

        newsItem("Стажировка на алгопроге", String.raw"""
            В этом году летом опять будет проходить <a href="/material/internship">стажировка на алгопроге</a>. Кто хочет поучаствовать, пишите.
        """),
        
        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
