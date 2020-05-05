import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic39867 = () ->
    return topic("Матрицы и их применение к ДП", "10Б: Задачи на матрицы", [
        label("<h4>Матрицы и их применение к ДП</h4>\n<p>См.\n<a href=\"http://e-maxx.ru/algo/linear_systems_gauss\">теорию по методу Гаусса на e-maxx</a>. Теории по применению матриц к ДП в удобоваримом виде я не нашел.\n</p>"),
        problem(76),
    ])

topic39865 = () ->
    return topic("Паросочетание максимального веста, венгерский алгоритм", "10Б: Задачи на венгерский алгоритм", [
        label("<h4>Паросочетание максимального веста, венгерский алгоритм</h4>\n<p>См.\n<a href=\"http://e-maxx.ru/algo/assignment_hungary\">теорию на e-maxx</a>, но <a href=\"http://e-maxx.ru/algo/assignment_mincostflow\">можно писать и mincost-maxflow</a>.\n</p>"),
        problem(111556),
    ])

export default level_10B = () ->
    return level("10Б", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        label("<h4>Mincost-maxflow</h4>\n<p>См. <a href=\"http://e-maxx.ru/algo/min_cost_flow\">теорию на e-maxx</a>\n</p>\n<p>Я не нашел на информатиксе задач на эту тему :(</p>"),
        topic39865(),
        topic39867(),
    ])