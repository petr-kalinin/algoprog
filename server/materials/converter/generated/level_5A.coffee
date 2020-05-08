import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_16955 = () ->
    return topic("Задачи средней сложности на ДП", "5А: Задачи средней сложности на ДП", [
        problem(212),
        problem(492),
        problem(587),
        problem(515),
        problem(545),
        problem(208),
        problem(1129),
    ])

topic_17237 = () ->
    return topic("Хеширование", "5А: Задачи на хеширование", [
        label("Основной теории тут пока нет, поищите в интернете.<br>\nДополнительная теория (предполагает, что вы уже почитали основную теорию): <a href=\"http://blog.algoprog.ru/hash-no-multiply\">как писать хеширование без домножения</a>.<br>\nЕще полезное <a href=\"https://codeforces.com/blog/entry/4898\">про антихештесты</a>."),
        problem(99),
        problem(100),
        problem(1042),
        problem(1943),
        problem(1326),
    ])

topic_16951 = () ->
    return topic("Тернарный (троичный) поиск", "5А: Задачи на тернарный поиск", [
        label("См. <a href=\"http://sis.khashaev.ru/2013/july/b-prime/t8O8TB6m_d8/\">видеозаписи лекций ЛКШ.2013.B', раздел \"тернарный поиск\"</a>"),
        problem(3398),
        problem(3859),
        problem(1116),
    ])

export default level_5A = () ->
    return level("5А", [
        label("Чтобы перейти на сладующий уровень, надо решить все задачи."),
        topic_16951(),
        topic_16955(),
        topic_17237(),
    ])