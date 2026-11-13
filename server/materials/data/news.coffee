import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("Добавлены правила использования нейросетей/ИИ", String.raw"""
            Добавлены <a href='/material/about_llm'>правила использования нейросетей/ИИ/LLM.</a>
        """),

        newsItem("Канал новостей алгопрога", String.raw"""
            Напоминаю про существование канала новостей алгопрога в телеграм: <a href="https://t.me/algoprog_news">@algoprog_news</a>,
            там я публикую новости и изменения в работе сайта.
            (Если ссылка на t.me заблокирована, просто в телеграмме поищите канал «algoprog_news».)
        """),

        newsItem("Добавлен телеграм-бот, который оповещает о комментариях", String.raw"""
            Вы теперь можете получать в телеграмме уведомления о зачтенных/проигнорированных решениях, 
            и комментариях. <a href="/material/telegram_bot">Подробнее</a>
        """),

        newsItem("Добавлен чат для учеников алгопрога", String.raw"""
            Добавлен <a href="https://t.me/+Ff0fS3PMo85iNmZi">чат для пользователей алгопрога</a>. 
            Чтобы вступить, надо сначала указать свой телеграм-аккаунт в профиле на алгопроге.
        """),

        newsItem("Опрос про алгопрог", String.raw"""
            Ответьте, пожалуйста, <a href="https://docs.google.com/forms/d/e/1FAIpQLSdDXTZ1yMHp_yk3Di5ie4BcI9HXKtnlJ8iyp9iupdX4fezqag/viewform?usp=sf_link">на несколько вопросов</a>. Тем, кто уже отвечал — я там добавил несколько вопросов, можете ответить еще раз.
        """),
    ])
