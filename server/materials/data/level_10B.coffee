import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import topic from "../lib/topic"

topic_module_39862_0 = () ->
    return topic("Mincost-maxflow", null, [
        label("<p>См. <a href=\"https://e-maxx.ru/algo/min_cost_flow\">теорию на e-maxx</a>\n</p>\n<p>Я не нашел на информатиксе задач на эту тему :(</p>"),
    ])

topic_39865 = () ->
    return topic("Паросочетание максимального веста, венгерский алгоритм", "10Б: Задачи на венгерский алгоритм", [
        label("<p>См.\n<a href=\"https://e-maxx.ru/algo/assignment_hungary\">теорию на e-maxx</a>, но <a href=\"https://e-maxx.ru/algo/assignment_mincostflow\">можно писать и mincost-maxflow</a>.\n</p>"),
        problem(111556),
    ])

topic_39867 = () ->
    return topic("Матрицы и их применение к ДП", "10Б: Задачи на матрицы", [
        label("<p>См.\n<a href=\"https://e-maxx.ru/algo/linear_systems_gauss\">теорию по методу Гаусса на e-maxx</a>. Теории по применению матриц к ДП в удобоваримом виде я не нашел.\n</p>"),
        problem(76),
    ])

export default level_10B = () ->
    return level("10Б", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic_module_39862_0(),
        topic_39865(),
        topic_39867(),
    ])