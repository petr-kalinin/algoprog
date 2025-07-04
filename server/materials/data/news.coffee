import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("Алгопрог переведен на новый учебный год, многие аккаунты деактивированы", String.raw"""
            Я перевел алгопрог на новый учебный год, и деактивировал аккаунты всех школьников. 
            Если вы планируете продолжать заниматься, напишите мне, указав, в какой школе и в каком классе вы будете обучаться,
            я активирую аккаунт обратно.
        """),

        newsItem("С 1 июля занятия для нижегородских школьников становятся частично платными", String.raw"""
            С 1 июля меняются условия оплаты занятий для нижегородских школьников. А именно, 
            для учеников лицея 40 занятия остаются бесплатными. Для остальных нижегородских 
            школьников занятия в старом формате (когда я проверяю решения и т.д.) становятся платными;
            при этом остается вариант заниматься бесплатно, но без взаимодействия со мной (я не буду проверять
            ваши решения и т.п.). <a href="/pay">Подробнее</a>
        """),

        newsItem("С 1 июля меняется стоимость занятий", String.raw"""
            С 1 июля меняется стоимость занятий на алгопроге. <a href="/pay">Подробнее</a>
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
