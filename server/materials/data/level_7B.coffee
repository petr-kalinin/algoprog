import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import topic from "../lib/topic"

topic_25519 = () ->
    return topic("Sqrt-декомпозиция, она же корневая эвристика", "7Б: Задачи на sqrt-декомпозицию", [
        label("<p><a href=\"https://e-maxx.ru/algo/sqrt_decomposition\">Теория на e-maxx</a><br>\n<a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Статистики_на_отрезках._Корневая_эвристика\">Теория в конспектах ИТМО</a><br>\n<a href=\"https://habrahabr.ru/post/138946/\">Статья на хабре</a></p>\n<p>Тут нашлась только одна задача, но можете еще попробовать порешать задачи из следующих тем.</p>"),
        problem(934),
        problem(1361),
    ])

topic_22523 = () ->
    return topic("Дерево отрезков", "7Б: Задачи на дерево отрезков", [
        label("<p><a href=\"https://e-maxx.ru/algo/segment_tree\">Теория на e-maxx</a><br>\n<a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Дерево_отрезков._Построение\">Теория на сайте ИТМО</a><br>\n<a href=\"https://habrahabr.ru/post/115026/\">Статия на хабре</a></p>"),
        problem(752),
        problem(753),
        problem(1364),
        problem(3312),
        problem(3321),
        problem(3335),
    ])

topic_25528 = () ->
    return topic("Декартово дерево", "7Б: Задачи на декартовы деревья", [
        label("<p>Для начала почитайте про <a href=\"https://ru.wikipedia.org/wiki/Двоичное_дерево_поиска\">двоичные деревья поиска</a>, ну или <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Дерево_поиска%2C_наивная_реализация\">еще здесь</a>. Вам не обязательно (пока) уметь их писать, но просто поймите, что это такое и с чем его едят.</p>\n<p><a href=\"https://e-maxx.ru/algo/treap\">Теория на e-maxx</a><br>\n<a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Декартово_дерево\">Теория на сайте ИТМО</a><br>\n<a href=\"https://www.mkurnosov.net/teaching/uploads/DSA/dsa-fall2014-lec7.pdf\">Еще какая-то теория</a><br>\n<a href=\"https://opentrains.mipt.ru/zksh/files/zksh2015/lectures/zksh_cartesian.pdf\">Еще какая-то теория</a><br>\nМожете еще погуглить\n</p>"),
        problem(2782),
        problem(1363),
        problem(2790),
    ])

export default level_7B = () ->
    return level("7Б", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic_25519(),
        topic_22523(),
        topic_25528(),
    ])