import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_35705 = () ->
    return topic("Групповые операции на деревьях", "9Б: Задачи на групповые операции", [
        label("<p>См. <a href=\"http://e-maxx.ru/algo/segment_tree#20\">теорию на e-maxx</a>.</p>"),
        problem(3327),
        problem(3329),
        problem(3328),
        problem(111800),
    ])

topic_35709 = () ->
    return topic("Многомерные деревья", "9Б: Задачи на многомерные деревья", [
        label("<p>См. теорию на e-maxx: <a href=\"http://e-maxx.ru/algo/segment_tree#25\">деревья отрезков</a>, <a href=\"http://e-maxx.ru/algo/fenwick_tree#4\">дерево Фенвика</a>.</p>"),
        problem(3013),
        problem(111778),
    ])

topic_35707 = () ->
    return topic("Бор и алгоритм Ахо-Корасик", "9Б: Задачи на бор и Ахо-Корасик", [
        label("<p>См. <a href=\"http://e-maxx.ru/algo/aho_corasick\">теорию на e-maxx</a>.</p>"),
        problem(111729),
        problem(111732),
    ])

export default level_9B = () ->
    return level("9Б", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic_35705(),
        topic_35707(),
        topic_35709(),
    ])