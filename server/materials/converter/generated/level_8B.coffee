import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_26201 = () ->
    return topic("Сложные задачи на ДП", "8Б: Сложные задачи на ДП", [
        problem(1793),
        problem(1720),
        problem(3898),
        problem(111490),
    ])

topic_26203 = () ->
    return topic("Декартово дерево по неявному ключу", "8Б: Задачи на декартово дерево по неявному ключу", [
        label("<p><a href=\"http://e-maxx.ru/algo/treap#7\">Теория на e-maxx</a><br>\n<a href=\"https://habrahabr.ru/post/102364/\">теория на хабре</a><br>\nДумаю, еще много чего легко ищется в интернете</p>"),
        problem(2791),
        problem(111881),
    ])

topic_26205 = () ->
    return topic("Геометрия средней сложности", "8Б: Задачи на среднюю геометрию", [
        label("<p>Материал должен быть ближе к концу соответствующей лекции <a href=\"http://sis.khashaev.ru/2013/july/b-prime/\">в ЛКШ.2013.B'</a><br>\nТакже можете смотреть нужные по каждой задаче разделы на e-maxx.</p>"),
        problem(289),
        problem(288),
        problem(1877),
        problem(2979),
        problem(3858),
    ])

export default level_8B = () ->
    return level("8Б", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic_26201(),
        topic_26203(),
        topic_26205(),
    ])